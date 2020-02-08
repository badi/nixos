{ pkgs, config, lib, ...}:

let
  secrets = pkgs.callPackage ../secrets {};
in

{

  # services.openvpn.servers.streisand = {
  #   config = secrets.vpn.streisand."${config.networking.hostName}".config;
  # };

  services.openvpn.servers.expressvpn = {
    config = secrets.vpn.expressvpn."${config.networking.hostName}".config;
  };

}
