# Adapted from
# https://github.com/grahamc/network/blob/master/router/default.nix

{ config, pkgs, lib, ... }:

let

  inherit (pkgs) writeText;
  inherit (lib) attrNames concatStringsSep catAttrs mapAttrs mapAttrsToList optionalString;
  inherit (builtins) toString;

  secrets = import ../secrets {};

  wan-iface-name = "wan0";
  wan-iface = { "${wan-iface-name}" = { mac = "00:0e:c4:d2:36:1d"; }; };

  ip4 = a: b: c: d: {inherit a b c d;};
  ip4ToString = ip: concatStringsSep "." (map toString [ip.a ip.b ip.c ip.d]);

  mk-lan-iface = { ip4, prefix ? 24, mac, subnet}: { inherit ip4 mac subnet prefix;};
  mk-subnet = {
                min, max, subnet
              , netmask ? ip4 255 255 255 0
              , broadcast ? subnet // { d = 255; }
              , prefix ? 24
              , static-hosts ? {}
              }:
              { inherit min max subnet netmask broadcast prefix static-hosts;
                cidr = "${ip4ToString subnet}/${toString prefix}"; };

  lan-ifaces = {
    lan0 = mk-lan-iface
      { ip4 = ip4 10 0 1 1;
        mac = "00:0e:c4:d2:36:1e";
        subnet = mk-subnet (lib.fix (self:
                           { min = ip4 10 0 1 100;
                             max = ip4 10 0 1 254;
                             subnet = ip4 10 0 1 0;
                             static-hosts = { tolu = {
                                                mac = "18:65:90:e1:33:85";
                                                ip = self.subnet // { d=10; };
                                              };
                                              fangorn = {
                                                mac = "4c:cc:6a:28:33:18";
                                                ip = self.subnet // { d=11; };
                                              };
                                            };
                           }));
      };
    lan1 = mk-lan-iface
      { ip4 = ip4 10 0 2 1;
        mac = "00:0e:c4:d2:36:1f";
        subnet = mk-subnet { min = ip4 10 0 2 100;
                             max = ip4 10 0 2 254;
                             subnet = ip4 10 0 2 0;
                           };
      };
    lan2 = mk-lan-iface 
      { ip4 = ip4 10 0 3 1; 
        mac = "00:0e:c4:d2:36:20";
        subnet = mk-subnet (lib.fix (self:
                           { min = ip4 10 0 3 100;
                             max = ip4 10 0 3 254;
                             subnet = ip4 10 0 3 0;
                            }));
      };
  };

  upstream-dns-servers = {
    google = [ (ip4 8 8 8 8) (ip4 8 8 4 4) ];
    alternate-dns = [ (ip4 23 253 163 53) (ip4 198 101 242 72) ];
    adguard = [ (ip4 176 103 130 130) (ip4 176 103 130 131) ];
  };

  dhcp-dns-servers = map ip4ToString upstream-dns-servers.google;
  domain-name = "badi.sh";

  mk-udev-rewrite-iface-name = eth: ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${eth.addr}", NAME="${eth.name}"
  '';

  udev-rewrite-iface-name = let
    mk-iface = name: x: {inherit name; addr = x.mac; };
    ifaces = mapAttrsToList  mk-iface (wan-iface // lan-ifaces);
    in lib.concatMapStrings mk-udev-rewrite-iface-name ifaces;

in

{

  imports = [
    ./hardware.nix

    # non-router-specific configuration go here
    ./system.nix
  ];

  services.udev.extraRules = udev-rewrite-iface-name;

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.${wan-iface-name}.accept_ra" = 2;
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = attrNames lan-ifaces;
  };
  # networking.firewall.extraCommands = let

  #   drop-on = {port, proto, ...}: ''
  #     ip46tables -A nixos-fw -p ${proto} --dport ${toString port} -j nixos-fw-refuse
  #   '';

  #   refuse-on = {port, proto, iface, ...}: ''
  #     ip46tables -A nixos-fw -p ${proto} -i ${iface} --dport ${toString port} -j nixos-fw-log-refuse
  #   '';

  #   accept-on = {port, proto, iface, ...}: ''
  #     ip46tables -A nixos-fw -p ${proto} -i ${iface} --dport ${toString port} -j nixos-fw-accept
  #   '';

  #   allow-from = {port, proto, from, ...}: ''
  #     iptables -A nixos-fw -p {proto} -s ${from} --dport ${toString port} -j nixos-fw-accept
  #   '';

  # in [];

  networking.interfaces = let
    mk-iface = name: iface:
      { ip4 = [ { address = ip4ToString iface.ip4;
                  prefixLength = iface.prefix;
                }
              ];
      };
    in mapAttrs mk-iface lan-ifaces;

  networking.nat = {
    enable = true;
    externalInterface  = wan-iface-name;
    internalInterfaces = attrNames lan-ifaces;
    internalIPs = mapAttrsToList (_: iface: iface.subnet.cidr) lan-ifaces;
    forwardPorts = [
      { destination = "${ip4ToString lan-ifaces.lan0.subnet.static-hosts.fangorn.ip}:22";
        proto = "tcp";
        sourcePort = 2014;
      }
      { destination = "${ip4ToString lan-ifaces.lan0.subnet.static-hosts.fangorn.ip}:80";
        proto = "tcp";
        sourcePort = 80;
      }
      { destination = "${ip4ToString lan-ifaces.lan0.subnet.static-hosts.fangorn.ip}:443";
        proto = "tcp";
        sourcePort = 443;
      }
    ];
  };

  services.miniupnpd = {
    enable = false;
    externalInterface = wan-iface-name;
    internalIPs = attrNames lan-ifaces;
    natpmp = false;             # commonly used for Apple devices
  };

  # for IPv6
  services.radvd = {
    enable = false;
      config = let
        mk-config-for = iface: ''
          interface ${iface}
          {
            AdvSendAdvert on;
            prefix ::/64
            {
              AdvOnLink on;
              AdvAutonomous on;
            };
          };
        '';
    in lib.concatMapStrings mk-config-for (lib.catAttrs "name" lan-ifaces);
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = attrNames  lan-ifaces;
    extraConfig =
      let
        mk-static-addr = subnet:
          let
            to-dhcpd-config = hostname: {mac, ip}: ''
              host ${hostname} {
                hardware ethernet ${lib.toUpper mac};
                fixed-address ${ip4ToString ip};
              }
            '';
          in lib.concatStrings (lib.mapAttrsToList to-dhcpd-config subnet.static-hosts);
        mk-subnet = iface-name: lan: ''

        subnet ${ip4ToString lan.subnet.subnet} netmask ${ip4ToString lan.subnet.netmask} {
          range ${ip4ToString lan.subnet.min} ${ip4ToString lan.subnet.max};
          option broadcast-address ${ip4ToString lan.subnet.broadcast};
          option routers ${ip4ToString lan.ip4};
          option domain-name-servers ${ip4ToString lan.ip4};
          option domain-name "${domain-name}";
          ddns-domainname "${domain-name}";
          ddns-rev-domainname "in-addr.arpa.";

          ${mk-static-addr lan.subnet}
        }
      '';
      in lib.concatStrings ([
        ''
          option domain-name "${domain-name}";
          log-facility local7;

          include "/etc/bind/rndc.key";
          ddns-updates on;
          ddns-update-style interim;
          update-static-leases on;
          authoritative;
          allow unknown-clients;
          use-host-decl-names on;

          zone ${domain-name}. {
            primary 127.0.0.1;
            key rndc-key;
          }
          zone 0.10.in-addr.arpa. {
            primary 127.0.0.1;
            key rndc-key;
          }
        ''
        ]
        ++ mapAttrsToList mk-subnet lan-ifaces);
          # option domain-name-servers ${lib.concatStringsSep "," dhcp-dns-servers};
  };

  services.bind =
    let
      cfg = config.services.bind;
      soaDef = {
        name = domain-name;
        serial = "10";
        refresh = "60"; retry = "60"; expire = "300"; minimum= "900";
      };
      mk-soa = {ttl ? "60", domain ? domain-name, ns ? "fea", email ? "io.badi.sh.", soa ? soaDef }:
        ''
          $TTL ${ttl}
          @  IN    SOA    ${ns}.${domain}.    ${email}  (
                                   ${soa.serial}
                                   ${soa.refresh}
                                   ${soa.retry}
                                   ${soa.expire}
                                   ${soa.minimum}
                                   )
          ;
        '';
      mk-bind-file = name: writeText "bind.${name}";
      forward-domain = mk-bind-file "${domain-name}.forward" ''
        ${mk-soa {}}
                 IN    NS     fea
        ;
        fea      IN    A      ${ip4ToString lan-ifaces.lan0.ip4}
        unifi    IN    CNAME  fangorn
        cloud    IN    CNAME  fangorn
      '';
      rev-domain = mk-bind-file "10.0.rev" ''
        ${mk-soa { soa = soaDef // {name = "10.0.in-addr.arpa";}; }}
                 IN    NS     fea.${domain-name}.
                 IN    PTR    fea.${domain-name}.
        ;
      '';
      mk-named-entry-list = xs: lib.concatMapStrings (entry: " ${entry}; ") xs;
    in {
    enable = true;
    listenOn = [ "127.0.0.1" ] ++ mapAttrsToList (_: iface: ip4ToString iface.ip4) lan-ifaces;
    cacheNetworks = [ "127.0.0.0/24" ] ++ mapAttrsToList (name: iface: iface.subnet.cidr) lan-ifaces;
    forwarders = dhcp-dns-servers;
    configFile = writeText "named.conf" ''
      include "/etc/bind/rndc.key";
      acl internals {  ${mk-named-entry-list cfg.cacheNetworks} };
      options {
        directory "/var/run/named";
        pid-file "/var/run/named/named.pid";
        statistics-file "/var/run/named/named_stats.txt";
        listen-on { ${mk-named-entry-list cfg.listenOn} };

        forwarders { ${mk-named-entry-list cfg.forwarders} };
        allow-query { internals; };
        allow-transfer { internals; };
      };
      zone "${domain-name}" {
        type master;
        file "${forward-domain}";
        allow-update { key rndc-key; };
      };
      zone "0.10.in-addr.arpa" {
        type master;
        file "${rev-domain}";
        allow-update { key rndc-key; };
      };
    '';
    };

    # When using DDN, BIND attempts to update the zone files in-place,
    # which will not work in /nix/store/...
    # Instead, make the startup phase copy to a read+write locations
    # and point the start command there.
    systemd.services.bind.preStart = ''
      WORKDIR=/var/lib/named
      CONF=$WORKDIR/named.conf
      mkdir -p $WORKDIR
      cp -v ${config.services.bind.configFile} $CONF
      chmod 0600 $CONF
      for path in $(grep -o "/nix/store/[a-zA-Z0-9\-\.]*.bind[^\"]*" $CONF); do
        name=$(echo $path | sed -E 's|(/nix/store/[a-z0-9\-]+.)||')
        newpath=$WORKDIR/$name
        cp -v $path $newpath
        sed -i -E "s|$path|$newpath|g" $CONF
        chmod 0600 $newpath
      done
      chown -R named:nogroup $WORKDIR
    '';
    systemd.services.bind.serviceConfig.ExecStart = lib.mkForce (
      let cfg = config.services.bind; bindUser = "named"; in
      "${pkgs.bind.out}/sbin/named -u ${bindUser} ${optionalString cfg.ipv4Only "-4"} -c /var/lib/named/named.conf -f"
    );

  services.fail2ban.enable = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi;
  };

  services.nginx = {
    enable = false;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    virtualHosts."unifi.${domain-name}" = {
      locations."/" = {
        proxyPass = "http://fea.${domain-name}:8080/";
        extraConfig = ''
          proxy_redirect https://fea.${domain-name}:8080/ http://$host/;
        '';
      };
    };
  };

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = secrets.namecheap.username;
    password = "'${secrets.namecheap.password}'";
    domain = "fangorn";
  };

  services.prometheus.unifiExporter = {
    enable = true;
    port = 9101;
    unifiTimeout = "2m";
    unifiAddress = "https://unifi.${domain-name}:8443";
    unifiInsecure = true;
    unifiUsername = secrets.unifiExporter.username;
    unifiPassword = secrets.unifiExporter.password;
  };

}
