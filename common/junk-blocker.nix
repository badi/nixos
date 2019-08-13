{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "10y2cbhfl15gn95xbvn2dkwjmlmij1xm86cszlqpb844vfrxyinc";
  });

}
