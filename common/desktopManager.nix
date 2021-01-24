{ pkgs, config, lib, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";

  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  environment.systemPackages = with pkgs;
  # (with gnome3; [
  #   adwaita-icon-theme
  #   defaultIconTheme
  #   eog
  # ]) ++

  [
    xscreensaver
    gnome-breeze
    hicolor-icon-theme
    gnome3.eog
    pcmanfm
    compton-git
    # fbpanel  # 2020-08-29 nixpkgs-unstable broken
    feh
    flameshot
    networkmanagerapplet
    pasystray
    pa_applet
    pavucontrol
    rofi
    # taffybar                    # 20.03
    # haskellPackages.gtk-sni-tray
    haskellPackages.status-notifier-item

  ]
  ++ lib.optionals config.services.xserver.desktopManager.gnome3.enable (with gnome3; [
    gnome-tweaks
  ])

  ;

  fonts = {
    enableDefaultFonts = true;
    # enableCoreFonts = true;     # 20.03
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

}
