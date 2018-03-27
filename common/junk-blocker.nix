{ pkgs, ... }:

{

  networking.extraHosts = builtins.readFile (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    sha256 = "1b7v0dsj8k9r04kj562pa7qw4vbxv8zf2a0kcaixxbdpdaad5ymp";
  });

}
