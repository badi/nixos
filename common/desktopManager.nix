{ pkgs, config, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";
  hardware.bluetooth.enable = true;

  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs; [
    xscreensaver
    gnome-breeze
    gnome_themes_standard
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
