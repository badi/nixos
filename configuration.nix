# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./irmo/hardware-configuration.nix
    ./hardware/yubico/yubikey.nix

    ./audio.nix
    ./boot.nix
    ./environment.nix
    ./fonts.nix
    ./i18n.nix
    ./nix.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./time.nix
    ./users.nix
    ./zram.nix
  ];

  # hardware.bluetooth.enable = false;

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

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.kde5.enable = true;
  kde.extraPackages = with pkgs.kde5; [
    bluedevil gwenview kate kcalc kcompletion kconfig
    ksysguard okular print-manager powerdevil kcmutils
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
