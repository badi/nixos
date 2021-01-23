# Adapted from
# https://github.com/grahamc/network/blob/master/router/default.nix

{ config, pkgs, lib, ... }:

let

  inherit (pkgs) writeText;
  inherit (lib) attrNames concatStringsSep catAttrs mapAttrs mapAttrsToList optionalString;
  inherit (builtins) toString;

  secrets = pkgs.callPackage ../secrets {};

  ifaces = {
    eth0.mac = "00:0e:c4:d2:36:1d";
    eth1.mac = "00:0e:c4:d2:36:1e";
    eth2.mac = "00:0e:c4:d2:36:1f";
    eth3.mac = "00:0e:c4:d2:36:20";
  };

  domain-name = "badi.sh";

  mk-udev-rewrite-iface-name = eth: ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${eth.addr}", NAME="${eth.name}"
  '';

  udev-rewrite-iface-name = let
    mk-iface = name: x: {inherit name; addr = x.mac; };
  in lib.concatMapStrings mk-udev-rewrite-iface-name (mapAttrsToList mk-iface ifaces);

in

{

  imports = [
    ./hardware.nix

    # non-router-specific configuration go here
    ./system.nix
  ];

  services.udev.extraRules = udev-rewrite-iface-name;

  networking.firewall.enable = false;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi;
  };

  services.ddclient = {
    enable = false;
    protocol = "namecheap";
    username = secrets.namecheap.username;
    password = "'${secrets.namecheap.password}'";
    domains = [ "fangorn" ];
  };

  services.prometheus.exporters.unifi = {
    enable = false;
    port = 9101;
    unifiTimeout = "5m";
    unifiAddress = "https://fea.${domain-name}:8443";
    unifiInsecure = true;
    unifiUsername = secrets.unifiExporter.username;
    unifiPassword = secrets.unifiExporter.password;
  };

}
