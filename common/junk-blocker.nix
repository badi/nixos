{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "0dcmb1cmimxmi5w75s9f818lqgdrlz4n6wild726gr2b8ncnb2rs";
  });

}
