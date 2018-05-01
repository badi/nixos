{ config, lib, pkgs, ... }:

let secrets = import ../secrets {};
in

{
  imports = [
    ../common/basicSystem.nix
    ./mailserver.nix
  ];

  networking.hostName = "nole";
  services.smartd.enable = false;

  services.fail2ban.enable = true;

  services.ddclient = {
    enable = true;
    inherit (secrets.ddclient.aleph) protocol username password;
    domains = [ "${config.networking.hostName}.${secrets.mailserver.domain}" ];
  };


}
