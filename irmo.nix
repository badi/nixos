# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./irmo/hardware-configuration.nix
  ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
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
  services.xserver.vaapiDrivers = [ pkgs.vaapiIntel ];

}
