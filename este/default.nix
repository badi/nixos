{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ../common/basicSystem.nix

      ../common/basicSystem.nix
      ../common/desktopManager.nix
      # ../common/nvidia.nix
      ../common/firefox-overlay.nix
      ../common/nix-config.nix

      ../common/users.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.displayManager.sddm.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.desktopManager.gnome3.sessionPath = with pkgs; [
    chrome-gnome-shell
  ];

  networking.hostName = "este";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [

    aria2
    emacs25
    firefox-overlay.firefox-nightly-bin
    google-chrome
    keepassx-community
    libreoffice
    okular
    wpsoffice

  ];


  users.extraUsers.mandos = {
    isNormalUser = false;
    group = "mandos";
  };

  users.extraGroups."mandos" = {
     members = [ "badi" "melissa" ];
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

  services.syncthing = {
    enable = true;
    user = "melissa";
    dataDir = "/home/melissa/.syncthing";
    openDefaultPorts = true;
    useInotify = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };


  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  services.printing.enable = true;

  services.xserver.libinput.enable = true;

  users.extraUsers.melissa = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$yQ/gOzSE$LX58qHAXQ/Ug0sYdG624F0J9Bh6rc1IngDdNA2ijV/qkO8SoakJa1uHJ6DnPyNz7tm.nPKDPFB5wCkjlLj.yE.";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
