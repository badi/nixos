{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "0ynz8nii1kgivs6ap3i1a8lcdwrbzzwm3gbdj89fvk40796dwijp";
  });

}
