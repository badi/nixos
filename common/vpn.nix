{ pkgs, config, ...}:

let
  secrets = import ../secrets.nix {};

  inherit (pkgs) lib;
  inherit (builtins) readFile toFile replaceStrings;

  ovpn_cfgs = pkgs.fetchzip {
    url = "https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip";
    stripRoot = false;
    sha256 = "0avrmi649226jx0jscfmb6v34cw8lcl6mh324r8bjczylzxqcc58";
  };

  auth_file = secrets.nordvpn.auth_file;

  p2pcfg = readFile "${ovpn_cfgs}/ovpn_tcp/us1238.nordvpn.com.tcp.ovpn";
  cfg = replaceStrings ["auth-user-pass"] ["auth-user-pass ${auth_file}"] p2pcfg;

in

{
  services.openvpn.servers.nordvpn.config = cfg;
}
