# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./desktopManager.nix

    ./hardware/yubico/yubikey.nix
    ./audio.nix
    ./boot.nix
    ./environment.nix
    ./fonts.nix
    ./i18n.nix
    ./nix.nix
    ./networking.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./time.nix
    ./users.nix
    ./zram.nix

    ./monitoring.nix

    ./main.nix

  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
