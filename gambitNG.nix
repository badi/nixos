{ config, pkgs, ... }:

   import ./basicSystem.nix    {inherit pkgs config;}
// import ./desktopManager.nix {inherit pkgs config;}
// import ./monitoring.nix     {inherit pkgs config;}
// {

  imports = [ ./gambit/hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Crucial_CT1024MX200SSD1_15030E747E7E";

  # /etc/machine-id
  # '16-04-18: 2f610599c12a424a80bd5b88fa8cf426
  networking.hostId = "6c7cbbf3";
  networking.hostName = "gambit";

}
