{ pkgs, config, ...}:

let
  secrets = import ../secrets.nix {};

  inherit (pkgs) lib;
  inherit (builtins) readFile toFile replaceStrings;

  ovpn_cfgs = pkgs.fetchzip {
    url = "https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip";
    stripRoot = false;
    sha256 = "0mchkv6j8qg4w64ri7z9ax92r7bx2cn5ckjqij35rcnyx6gqr33d";
  };

  auth_file = secrets.nordvpn.auth_file;

  p2pcfg = readFile "${ovpn_cfgs}/ovpn_tcp/us1238.nordvpn.com.tcp.ovpn";
  cfg = replaceStrings ["auth-user-pass"] ["auth-user-pass ${auth_file}"] p2pcfg;

in

{
  services.openvpn.servers.nordvpn.config = cfg;
}
