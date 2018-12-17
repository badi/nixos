{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "0755vpzhy0wcgc0lpfcmbkmbdrm42x6w5znlyjbdfxr6lkbpqp0s";
  });

}
