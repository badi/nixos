{ config, pkgs, ... }:

{

  imports = [ ./fangorn/hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
}
