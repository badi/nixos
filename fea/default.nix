# Adapted from
# https://github.com/grahamc/network/blob/master/router/default.nix

{ config, pkgs, lib, ... }:

let

  wan-iface =
    { name = "wan0"; mac = "00:0e:c4:d2:36:1d"; };
  lan-ifaces = [
    rec { name = "lan0"; octet = "10.1.0"; ip4 = "${octet}.1"; mac = "00:0e:c4:d2:36:1e"; }
    rec { name = "lan1"; octet = "10.2.0"; ip4 = "${octet}.1"; mac = "00:0e:c4:d2:36:1f"; }
    rec { name = "lan2"; octet = "10.3.0"; ip4 = "${octet}.1"; mac = "00:0e:c4:d2:36:20"; }
  ];
  router-ip = "10.0.0.1";

  # http://www.aboutmyip.com/AboutMyXApp/SubnetCalculator.jsp?ipAddress=10.1.0.0&cidr=22
  lan-cidr = "10.1.0.0/22";     # 10.1.0.1 -> 10.1.3.254
  subnet-mask = "255.255.252.0";
  dhcp-broadcast-address = "10.1.3.255";
  dhcp-dns-servers = [ "8.8.8.8" ];
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
    internalIPs = [ lan-cidr ];
  };

  # # for IPv6
  # services.radvd = {
  #   enable = true;
  #     config = let
  #       mk-config-for = iface: ''
  #         interface ${iface}
  #         {
  #           AdvSendAdvert on;
  #           prefix ::/64
  #           {
  #             AdvOnLink on;
  #             AdvAutonomous on;
  #           };
  #         };
  #       '';
  #   in lib.concatMapStrings mk-config-for (lib.catAttrs "name" lan-ifaces);
  # };

  services.dhcpd4 = {
    enable = true;
    interfaces = lib.catAttrs "name" lan-ifaces;
    extraConfig =
      let mk-subnet = lan: ''
        subnet ${lan.octet}.0 netmask ${subnet-mask} {
          range ${lan.octet}.10 ${lan.octet}.254;
        }
      '';
      in lib.concatStrings ([
        ''
          option subnet-mask ${subnet-mask};
          option broadcast-address ${dhcp-broadcast-address};
          option routers ${lib.concatStringsSep "," (lib.catAttrs "ip4" lan-ifaces)},${router-ip};
          option domain-name-servers ${lib.concatStringsSep "," dhcp-dns-servers};
          option domain-name "${domain-name}";

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
