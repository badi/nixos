{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "1qwnbbp2424hswskrb3pyvf3gm2pkppv8z8qgbsdq0sh91h76fdv";
  });

}
