{ config, pkgs, ... }:

{

  imports = [
    ./irmo/hardware-configuration.nix
    ./basicSystem.nix
    ./workstation.nix
    ./desktopManager.nix
    ./laptop.nix
    ./users.nix
    ./yubikey.nix
#    ./monitoring.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "b555bd11";
  networking.hostName = "irmo";

  services.xserver.xkbVariant = "mac";
  # services.xserver.multitouch.enable = true;
  # services.xserver.multitouch.tapButtons = true;
  # services.xserver.multitouch.ignorePalm = true;
  # services.xserver.multitouch.invertScroll = true;
  services.xserver.synaptics = {
    enable = true;
    accelFactor = "0.005";
    tapButtons = true;
    fingersMap = [ 0 0 0 ];
    buttonsMap = [ 1 3 2 ];
    twoFingerScroll = true;
    palmDetect = true;
  };
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

}
