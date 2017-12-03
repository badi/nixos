# this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./glaurung/hardware-configuration.nix

      ./common/basicSystem.nix
      ./common/firefox-nightly.nix
      ./common/kodi.nix
      ./common/nix-config.nix
      ./common/nvidia.nix
      ./common/syncthing.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-Crucial_CT525MX300SSD1_170115431CBA";

  networking.hostName = "glaurung"; # Define your hostname.


  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };


  nix.useSandbox = true;
  # nix.extraOptions = "binary-caches-parallel-connections = 50";
  nixpkgs.config.firefox.ffmpegSupport = true;

  environment.systemPackages = with pkgs; [
    wget
    emacs25-nox
    git
    google-chrome
    spotify
    skype
    tmux
    nix-repl
    nmap
    pv
    silver-searcher
    telnet
    gwenview
    kate
  ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";
  hardware.bluetooth.enable = true;

  services.unified-remote.enable = true;
  services.unified-remote.openFirewall = true;

  services.ntp.enable = true;

  services.synergy.client.enable = true;
  services.synergy.client.serverAddress = "10.0.0.107";

  services.prometheus.nodeExporter.enable = true;
  services.prometheus.nodeExporter.openFirewall = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.enable = true;
  services.xserver.displayManager.sddm.autoLogin.user = "htpc";
  services.xserver.displayManager.sddm.extraConfig = ''
  [X11]
  ServerArguments=-dpi 144
  '';
  services.xserver.desktopManager.plasma5.enable = true;

  users.extraUsers.badi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # fangorn
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINddUe+ma6S0Y27La0wGd5JVSiVwiza4Xal5dtYub0x0"
      # tolu
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvnljjiF48eoHjolTVhxrv9PiQnsjoc9mIExYPv7JZC"
      # este
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE6B4AQ8RRltw/iXJFgjN6yQT1vDD8k+64gR/HgIyeX"
    ];
  };

  users.extraUsers.htpc = {
    isNormalUser = true;
  };

  users.extraUsers.mandos = {
    isNormalUser = false;
    group = "mandos";
  };

  users.extraGroups."mandos" = {
     members = [ "htpc" "badi" ];
  };

  fileSystems."/mandos" = {
    device = "//10.0.0.2/mandos";
    fsType = "cifs";
    options = [
      "ro"
      "credentials=/var/lib/mandos/auth" "uid=mandos" "gid=mandos"
      "x-systemd.automount"
      "x-systemd.device-timeout=30s"
      "x-systemd.mount-timeout=10s"
    ];
  };

  system.stateVersion = "17.09";

  system.copySystemConfiguration = true;
  # this only copies configuration.nix even if it imports others

}
