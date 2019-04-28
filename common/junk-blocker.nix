{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "00vryk9i43lx4psi03gc81jsrnd1y72lylvhkrsfhnqgb3qm3bf6";
  });

}
