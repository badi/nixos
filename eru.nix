{config, pkgs, ...}:

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
  ];
  ec2.hvm = true;

  networking.hostName = "eru";
  networking.tcpcrypt.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  environment.systemPackages = with pkgs; [
    git emacs24-nox super-user-spark
  ];

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };


  # users.mutableUsers = false;
  users.extraUsers.badi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # badi@fangorn
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINddUe+ma6S0Y27La0wGd5JVSiVwiza4Xal5dtYub0x0 badi@fangorn abdulwahidc@gmail.com"
      # badi@fangorn nopass
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2StA8q/t+vblYXdLf0woNYv8akBhaH/P//BMwC9UtO badi@fangorn"
      # badi@gambit
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqoNyVmzGibqaa0rTLN5OdrVlczLrEULHJdynesL9eIOcJujYkmfZxPfd/lun9T8eopjpODVMiBqjQI8Sf9S76lgihY5c2KQcXMj+S6OgNFQJa8ve7e8cUS2KQtrcPpMcmpm62/5kB7CYP1I61TfLQfPSkoxkQ408hZ4sj1O4xYujbZIaWlSokcedoh7HjIkRcqUeeoxspyxPV9ftaFuCFcXVlDC7wSe9+SoeTmU8BygmgpAy19nezf24VDe1dVnpOMDqB7Qqa5nXABv5ZwUXMlU1uw5fPw05DkCB0bc5TqaMHcwT/U9IwSJunRXepXIFfvnBakScUGkq9Uld0RpJT"
    ];
  };


}
