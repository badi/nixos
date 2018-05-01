{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "062nhvvzbjc48k9wyq6cynhffclwnxf78x4vx2bp2n70ddackg7f";
  });

}
