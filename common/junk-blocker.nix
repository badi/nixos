{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "0lynqycqhycz8ly9bcjv9j8apv77w5dx504fyav990h8xsq18z28";
  });

}
