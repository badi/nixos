{ config, lib, ... }:

{

  services.openssh.enable = lib.mkDefault true;
  services.openssh.passwordAuthentication = lib.mkDefault false;
  services.openssh.permitRootLogin = lib.mkDefault "yes";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINddUe+ma6S0Y27La0wGd5JVSiVwiza4Xal5dtYub0x0 badi@fangorn"
    ];
  };


}
