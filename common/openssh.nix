{ config, lib, pkgs, ... }:

let
  secrets = pkgs.callPackage ../secrets {};
in

{

  services.openssh.enable = lib.mkDefault true;
  services.openssh.passwordAuthentication = lib.mkDefault false;
  services.openssh.permitRootLogin = lib.mkDefault "yes";

  users.users.root = {
    openssh.authorizedKeys.keys = secrets.ssh-keys.badi.fangorn;
  };


}
