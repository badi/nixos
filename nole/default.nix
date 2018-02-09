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
    protocol = "namecheap";
    username = secrets.namecheap.username;
    password = "'${secrets.namecheap.password}'";
    domain = config.networking.hostName;
  };


}
