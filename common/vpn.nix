{ pkgs, config, ...}:

let
  secrets = import ../secrets {};
in

{

  services.openvpn.servers.streisand = {
    config = secrets.vpn.streisand."${config.networking.hostName}".config;
  };

}
