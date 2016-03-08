{ pkgs, ... }:

{
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
}
