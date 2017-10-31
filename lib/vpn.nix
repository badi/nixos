{ pkgs ? import <nixos> {}
, ...}:

let
  inherit (pkgs) lib;
  inherit (builtins) readFile toFile replaceStrings;

  # ovpn_cfgs = fetch {
  #   name = "nordvpn.zip";
  #   url = "https://nordvpn.com/api/files/zip";
  #   stripRoot = false;
  #   sha256 = "ea2ac68dfd14bf5a4fbe90932608b959812483feac9d9d71bc1ad218e35f1e54";
  # };

  # fetchzip fails due to file being named simply "zip"
  ovpn_cfgs = "/root/nordvpn";
  auth_file = "/root/.nordvpn/auth";

  p2pcfg = readFile "${ovpn_cfgs}/ca-us2.nordvpn.com.tcp443.ovpn";
  cfg = replaceStrings ["auth-user-pass"] ["auth-user-pass ${auth_file}"] p2pcfg;

in

{
  services.openvpn.servers.nordvpn.config = cfg;
}
