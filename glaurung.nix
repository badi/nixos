# this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./glaurung/hardware-configuration.nix
      # ./compton.nix
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
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 8080 ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Eastern";

  nix.useSandbox = true;
  # nix.extraOptions = "binary-caches-parallel-connections = 50";
  nix.gc.automatic = true;
  nix.gc.dates = "monthly";
  nix.gc.options = "--delete-older-than 60d";
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.ffmpegSupport = true;

  nixpkgs.overlays =
    let
      nixpkgs-mozilla = pkgs.fetchgit {
        url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	sha256 = "1lim10a674621zayz90nhwiynlakxry8fyz1x209g9bdm38zy3av";
      };
      # nixpkgs-mozilla = "/home/badi/nixpkgs-mozilla";
      firefox-overlay = import "${nixpkgs-mozilla}/firefox-overlay.nix";
    in [
      (self: super: {
       inherit ((firefox-overlay self super).latest) firefox-nightly-bin;
      })
    ];

  environment.systemPackages = with pkgs; [
    wget
    emacs25-nox
    git
    kodi
    firefox-nightly-bin
    google-chrome
    spotify
    skype
    tmux
    nix-repl
    nmap
    telnet
  ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";
  hardware.bluetooth.enable = true;

  services.unified-remote.enable = true;
  services.unified-remote.openFirewall = true;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;

  services.ntp.enable = true;

  services.synergy.client.enable = true;
  services.synergy.client.serverAddress = "10.0.0.107";

  services.prometheus.nodeExporter.enable = true;
  services.prometheus.nodeExporter.openFirewall = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.videoDrivers = [ "nvidia" ];

  # https://wiki.archlinux.org/index.php/NVIDIA/Troubleshooting#Avoid_screen_tearing
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option "TipleBuffer" "on"
    Option "AllowIndirectGLXProtocol" "off"
  '';

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
