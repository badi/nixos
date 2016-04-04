# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nix.binaryCaches = [
    https://cache.nixos.org/
    http://hydra.cryp.to
  ];

  nix.trustedBinaryCaches = [
    https://cache.nixos.org/
    http://hydra.cryp.to
  ];

  nix.binaryCachePublicKeys = [
    "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
  ];

  boot.supportedFilesystems = [ "zfs" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


}
