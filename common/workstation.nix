{ pkgs, ... }:
{

  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; 
    [ xscreensaver ];

  
  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      bakoma_ttf
      corefonts
      dejavu_fonts
      gentium
      inconsolata
      liberation_ttf
      terminus_font
      ubuntu_font_family
    ];
  };

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";


  services.printing.enable = true;
  services.upower.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";

}
