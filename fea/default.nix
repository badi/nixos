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
    ../common/nix-config.nix
  ];


  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-MT-64_087081950063";

  services.udev.extraRules = udev-rewrite-iface-name;


  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    emacs
    pv
    tailscale
    tmux
  ];

  users.users.root = {
    openssh.authorizedKeys.keys =
      secrets.ssh-keys.badi.fangorn;
  };

  services.tailscale.enable = true;

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;

  sound.enable = false;

  time.timeZone = "US/Central";

  networking.firewall =
    let
      unifi-controller = [ 8443 ];
      prometheus-unifi = [ 9101 ];
    in  {
      enable = true;
      allowedTCPPorts = unifi-controller ++ prometheus-unifi;
    };

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
    enable = true;
    port = 9101;
    unifiTimeout = "5m";
    unifiAddress = "https://localhost:8443";
    unifiInsecure = true;
    unifiUsername = secrets.unifiExporter.username;
    unifiPassword = secrets.unifiExporter.password;
  };

}
