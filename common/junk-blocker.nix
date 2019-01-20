{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "01bhx494mpg5hb989fkxcaggl8xl4ca5wkqya7imb0x8amyi7453";
  });

}
