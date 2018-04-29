{ config, pkgs, lib, ... }:

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

    networkmanager.enable = false;
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

  services.syncthing.enable = true;
  services.syncthing.openDefaultPorts = true;

  sound.enable = false;

  system.stateVersion = "16.09";

}
