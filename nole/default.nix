{ config, lib, pkgs, ... }:

{
  imports = [
    ../common/basicSystem.nix
  ];

  networking.hostName = "nole";
  services.smartd.enable = false;

}
