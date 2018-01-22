{ pkgs, config, ...}:

let
  secrets = import ../secrets.nix {};

  inherit (pkgs) lib;
  inherit (builtins) readFile toFile replaceStrings;

  ovpn_cfgs = pkgs.fetchzip {
    url = "https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip";
    stripRoot = false;
    sha256 = "007arhgy5b537nara7wx31sbjjxp15b0v5fqxd5xrw81q9f1a31r";
  };

  auth_file = secrets.nordvpn.auth_file;

  p2pcfg = readFile "${ovpn_cfgs}/ovpn_tcp/us1238.nordvpn.com.tcp.ovpn";
  cfg = replaceStrings ["auth-user-pass"] ["auth-user-pass ${auth_file}"] p2pcfg;

in

{
  services.openvpn.servers.nordvpn.config = cfg;
}
