# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./irmo/hardware-configuration.nix
      ./hardware/yubico/yubikey.nix
    ];

  # hardware.bluetooth.enable = false;
  hardware.pulseaudio.enable = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent = 20;

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.zfs.forceImportAll = true;
  networking.hostId = "b555bd11";

  networking.hostName = "irmo";
  networking.interfaceMonitor.enable = true;
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      liberation_ttf
      dejavu_fonts
      bakoma_ttf
      gentium
      ubuntu_font_family
      terminus_font
    ];
  };

  nix = {
    useChroot = true;
    trustedBinaryCaches = [
      # https://hydra.cryp.to
      https://cache.nixos.org
    ];
    binaryCaches = [
      # https://hydra.cryp.to
      https://cache.nixos.org
    ];
    binaryCachePublicKeys = [ "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g=" ];
    extraOptions = ''
      binary-caches-parallel-connections = 50
    '';
  };
  
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;
  programs.light.enable = true;
  programs.kbdlight.enable = true;
  programs.bash.enableCompletion = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
    

  time.timeZone = "US/Eastern";

  environment.variables = {
    HOST = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  environment.systemPackages = with pkgs; [
    file lsof psmisc which hwdata iotop lshw
    wget curl
    vim emacs24-nox
    gitAndTools.gitFull
    xscreensaver
  ];

  services.locate.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "mac";
  # services.xserver.multitouch.enable = true;
  # services.xserver.multitouch.tapButtons = true;
  # services.xserver.multitouch.ignorePalm = true;
  # services.xserver.multitouch.invertScroll = true;
  services.xserver.synaptics = {
    enable = true;
    accelFactor = "0.005";
    tapButtons = true;
    fingersMap = [ 0 0 0 ];
    buttonsMap = [ 1 3 2 ];
    twoFingerScroll = true;
    palmDetect = true;
  };
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.vaapiDrivers = [ pkgs.vaapiIntel ];

  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde5.enable = true;
  kde.extraPackages = with pkgs.kde5; [
    bluedevil gwenview kate kcalc kcompletion kconfig
    ksysguard okular print-manager powerdevil kcmutils
  ];

  users.extraGroups.yubikey = {};
  users.extraUsers.badi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "yubikey" ];
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
