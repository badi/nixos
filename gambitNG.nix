{ config, pkgs, ... }:

{

  imports = [
    ./gambit/hardware-configuration.nix
    ./basicSystem.nix
    ./workstation.nix
    ./desktopManager.nix
    ./users.nix
    ./yubikey.nix
    ./monitoring.nix
    ./virthost.nix
  ];

  users.extraGroups.yubikey.members = [ "badi" ];
  users.extraGroups.networkmanager.members = [ "badi" ];
  users.extraGroups.libvirtd.members = [ "badi" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Crucial_CT1024MX200SSD1_15030E747E7E";

  # /etc/machine-id
  # '16-04-18: 2f610599c12a424a80bd5b88fa8cf426
  networking.hostId = "6c7cbbf3";
  networking.hostName = "gambit";

  system.stateVersion = "16.03";
  time.timeZone = "US/Eastern";

}