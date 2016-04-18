{ config, pkgs, ... }:

   import ./basicSystem.nix    {inherit pkgs config;}
// import ./desktopManager.nix {inherit pkgs config;}
// import ./monitoring.nix     {inherit pkgs config;}
// {

  imports = [ ./gambit/hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Crucial_CT1024MX200SSD1_15030E747E7E";

  networking.hostId = "6c7cbbf3";
  networking.hostName = "gambit";

  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.driSupport32Bit = true;
}
