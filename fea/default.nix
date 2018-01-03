# Adapted from
# https://github.com/grahamc/network/blob/master/router/default.nix

{ config, pkgs, lib, ... }:

let

  wan-iface = "wan0";
  lan-ifaces = [ "lan0" "lan1" "lan2" ];
  router-ip = "10.0.0.1";
  lan-cidr = "10.0.0.0/24";
  dhcp-broadcast-address = "10.0.0.255";
  dhcp-dns-servers = [ "8.8.8.8" ];
  domain-name = "badi.sh";

  ifaces = [
  { name = "wan1";
    addr = "00:0e:c4:d2:36:1d"; }
  { name = "lan1";
    addr = "00:0e:c4:d2:36:1e"; }
  { name = "lan2";
    addr = "00:0e:c4:d2:36:1f"; }
  { name = "lan3";
    addr = "00:0e:c4:d2:36:20"; }
  ];

  mk-udev-rewrite-iface-name = eth: ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${eth.addr}", NAME="${eth.name}"
  '';

  udev-rewrite-iface-name = lib.concatMapStrings mk-udev-rewrite-iface-name ifaces;

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
    "net.ipv6.conf.${wan-iface}.accept_ra" = 2;
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

  # networking.interfaces = let
  #   mk-iface = {face, address}: { name = face; value = { ip4 = [{inherit address; prefixLength = 24;}]; }; };
  #   faces = [
  #     # {face = "lan1"; address = "10.0.1.1"; }
  #     {face = "lan2"; address = "10.0.1.2";}
  #     {face = "lan3"; address = "10.0.1.3";}
  #   ];
  #   in builtins.listToAttrs (map mk-iface faces);

  # networking.nat = {
  #   enable = true;
  #   externalInterface  = wan-iface;
  #   internalInterfaces = lan-ifaces;
  #   internalIPs = [ lan-cidr ];
  # };

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
  #   in lib.concatMapStrings mk-config-for lan-ifaces;
  # };

  # services.dhcpd4 = {
  #   enable = true;
  #   interfaces = lan-ifaces;
  #   extraConfig = ''
  #     option subnet-mask 255.255.255.0;
  #     option broadcast-address ${dhcp-broadcast-address};
  #     option routers ${router-ip};
  #     option domain-name-servers ${lib.concatStringsSep "," dhcp-dns-servers};
  #     option domain-name ${domain-name};
  #   '';
  # };

  # services.avahi = {
  #   enable = true;
  #   interfaces = lan-ifaces;
  #   nssmdns = true;
  #   publish.enable = true;
  #   publish.userServices = true;
  # };

  services.fail2ban.enable = true;

}
