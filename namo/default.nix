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
    smbclient
    xfsprogs
    youtube-dl
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINddUe+ma6S0Y27La0wGd5JVSiVwiza4Xal5dtYub0x0 badi@fangorn"
    ];
  };

  services.smartd.enable = true;

  services.syncthing.enable = true;
  services.syncthing.useInotify = true;
  services.syncthing.openDefaultPorts = true;

  system.stateVersion = "16.09";

}
