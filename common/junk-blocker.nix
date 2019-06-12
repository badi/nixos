{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "0x8jyz2a6pg8xlh3fqcybqvps11v0zs5ajgqm4qd30s1fyksqr9f";
  });

}
