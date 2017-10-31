{packageChoices, pkgs, ...}:

let
  inherit (pkgs.lib) optional optionals;
in

{

  environment.systemPackages = with pkgs; [
    smbclient cifs_utils
  ]

  ++ optional withChrome google-chrome

  ;

}
