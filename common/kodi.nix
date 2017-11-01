{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    kodi
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

}
