{ pkgs, config, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";
  hardware.u2f.enable = true;
  hardware.bluetooth.enable = true;

  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: with haskellPackages; [
      xmonad-screenshot
      xmonad-spotify
      xmonad-utils
      xmonad-volume
      # xmonad-wallpaper
      # xmonad-windownames
    ];
  };

  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  environment.systemPackages = with pkgs;
  # (with gnome3; [
  #   adwaita-icon-theme
  #   defaultIconTheme
  #   gnome-bluetooth
  #   eog
  # ]) ++

  [
    xscreensaver
    gnome-breeze
    hicolor-icon-theme
    gnome3.eog
    pcmanfm
    blueman
    compton-git
    fbpanel
    feh
    flameshot
    networkmanagerapplet
    pasystray
    pa_applet
    pavucontrol
    rofi
    taffybar
    # haskellPackages.gtk-sni-tray
    haskellPackages.status-notifier-item

  ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      bakoma_ttf
      corefonts
      dejavu_fonts
      font-awesome-ttf
      gentium
      inconsolata
      liberation_ttf
      terminus_font
      ubuntu_font_family
      unifont
    ];
  };

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

}
