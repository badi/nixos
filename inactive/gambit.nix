{ config, pkgs, ... }:

{

  imports = [
    ./gambit/hardware-configuration.nix
    ./basicSystem.nix
    ./workstation.nix
    ./bluetooth.nix
    ./desktopManager.nix
    ./users.nix
    ./yubikey.nix
    ./virthost.nix
    ./syncthing.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Crucial_CT1024MX200SSD1_15030E747E7E";

  # /etc/machine-id
  # '16-04-18: 2f610599c12a424a80bd5b88fa8cf426
  # '16-09-19: 2f610599c12a424a80bd5b88fa8cf426
  networking.hostId = "6c7cbbf3";
  networking.hostName = "gambit";

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "badi.sh";
    password = pkgs.lib.readFile /var/lib/dyndns/badi.sh.password;
    domain = "gambit";
  };

}
