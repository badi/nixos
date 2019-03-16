{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "1vlx5dycfnrkyfgz9rx5x8dsb19ch61n2sbdfxbmlh2hjv2ns7k2";
  });

}
