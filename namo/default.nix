{ config, pkgs, lib, ... }:

let
  secrets = import ../secrets {};
in

{
  imports = [
    ../common/basicSystem.nix

    ./boot.nix
    ./samba.nix

    ../common/vpn.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    hostId = "33025074";
    hostName = "namo";
    usePredictableInterfaceNames = true;

    firewall.enable = lib.mkForce false;

    tcpcrypt.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gptfdisk
    mediainfo
    smbclient
    xfsprogs
    youtube-dl
  ];

  services.smartd.enable = true;

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;

  services.syncthing.enable = true;
  services.syncthing.openDefaultPorts = true;

  sound.enable = false;

  users.extraGroups.mandos.gid = 1002;
  users.extraUsers.badi = {
    isNormalUser = true;
    uid = 1001;
    createHome = true;
    extraGroups = [ "wheel" "mandos"];
    initialHashedPassword = "$6$57MWbD8YW3YKQsI$UUyMnkH0k8WDJ7vOt3cgkj8XVO7QBsVeR79GyqydEFmKtqAEg1n9y853BGgzc0QksNnlrUreguWxDsYrYipQU/";
    openssh.authorizedKeys.keys =
      secrets.ssh-keys.badi.fangorn;
  };



  i18n.consoleFont = "lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";


  system.stateVersion = "16.09";

}
