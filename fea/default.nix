# Adapted from
# https://github.com/grahamc/network/blob/master/router/default.nix

{ config, pkgs, lib, ... }:

let

  wan-iface =
    { name = "wan0"; mac = "00:0e:c4:d2:36:1d"; };

  # mk-lan-iface :: int -> {} -> {}
  mk-lan-iface = i: {subnet-from, mac, name ? "lan", router-octet ? "1", prefix-length ? 24, first-host ? 10 }:
    assert prefix-length == 24;
    { name = "name${builtins.toString i}";
      ip4 = "${subnet-from}.${router-octet}";
      cidr = "${subnet-from}.0/${builtins.toString prefix-length}";
      netmask = "255.255.255.0";
      broadcast = "${subnet-from}.255";
      host-min = "${subnet-from}.1";
      host-max = "${subnet-from}.254";
      first-host = "${subnet-from}.${builtins.toString first-host}";
      inherit subnet-from prefix-length mac;
    };

  lan-ifaces = [
    (mk-lan-iface 0 { subnet-from = "10.1.0"; mac = "00:0e:c4:d2:36:1e"; })
    (mk-lan-iface 1 { subnet-from = "10.1.1"; mac = "00:0e:c4:d2:36:1f"; })
    (mk-lan-iface 2 { subnet-from = "10.1.2"; mac = "00:0e:c4:d2:36:20"; })
  ];

  dhcp-dns-servers = [ "8.8.8.8" "8.8.4.4" ];
  domain-name = "badi.sh";

  mk-udev-rewrite-iface-name = eth: ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${eth.addr}", NAME="${eth.name}"
  '';

  udev-rewrite-iface-name = let
    mk-iface = x: {inherit (x) name; addr = x.mac; };
    ifaces = map mk-iface ([wan-iface] ++ lan-ifaces);
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
    "net.ipv6.conf.${wan-iface.name}.accept_ra" = 2;
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
    mk-iface = {face, address}: { name = face; value = { ip4 = [{inherit address; prefixLength = 24;}]; }; };
    faces = map (x: { face = x.name; address = x.ip4; }) lan-ifaces;
    in builtins.listToAttrs (map mk-iface faces);

  networking.nat = {
    enable = true;
    externalInterface  = wan-iface.name;
    internalInterfaces = lib.catAttrs "name" lan-ifaces;
    internalIPs = lib.catAttrs "cidr" lan-ifaces;
  };

  # for IPv6
  services.radvd = {
    enable = true;
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
    interfaces = lib.catAttrs "name" lan-ifaces;
    extraConfig =
      let mk-subnet = lan: ''

        subnet ${lan.subnet-from}.0 netmask ${lan.netmask} {
          range ${lan.first-host} ${lan.host-max};
          option broadcast-address ${lan.broadcast};
          option routers ${lan.host-min};
        }
      '';
      in lib.concatStrings ([
        ''
          option domain-name-servers ${lib.concatStringsSep "," dhcp-dns-servers};
        ''
        ]
        ++ map mk-subnet lan-ifaces);
  };

  # services.avahi = {
  #   enable = true;
  #   interfaces = lib.catAttrs "name" lan-ifaces;
  #   nssmdns = true;
  #   publish.enable = true;
  #   publish.userServices = true;
  # };

  # services.fail2ban.enable = true;

}
