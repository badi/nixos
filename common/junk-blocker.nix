{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "17k6wc95v03pzsv6jf0lv1yld4cnihqmc6v2nkyycmxam32a7ydk";
  });

}
