{ pkgs, config, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.daemon.config.flat-volumes = "no";

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  fonts = {
    enableDefaultFonts = true;
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
      unifont
    ];
  };

}
