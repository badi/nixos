{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "1gys7bakphlw7fz4nsr8bmab2id89sixhg9lbmbjj9vsb0i68117";
  });

}
