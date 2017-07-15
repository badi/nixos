{ config, pkgs, ... }:

{

  imports = [
    ./fangorn/hardware-configuration.nix
    ./basicSystem.nix
    ./workstation.nix
    ./desktopManager.nix
    ./bluetooth.nix
    ./users.nix
    ./yubikey.nix
    # ./monitoring.nix
    ./virthost.nix
    ./pia.nix
    ./popfile.nix
    ./syncthing.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_250GB_S1DBNSAF757040Z";

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [ 3000 ];

  services.xserver.videoDrivers = [ "nouveau" ];
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    smbclient cifs_utils
  ];

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "badi.sh";
    password = pkgs.lib.readFile /var/lib/dyndns/badi.sh.password;
    domain = "fangorn";
  };

}
