{ pkgs, config, ... }:

let

  all-the-icons-fn =
    {stdenv, fetchFromGitHub}:

    stdenv.mkDerivation {
      name = "all-the-icons";

      src = fetchFromGitHub {
        owner = "domtronn";
        repo = "all-the-icons.el";
        rev = "b2d923e51d23e84198e21b025c656bf862eaced6";
        sha256 = "0j5230nas9h6rn4wfsaf5pgd3yxxk615j68y2j01pjrrkxvrwqig";
      };

      dontBuild = true;
      phases = [ "installPhase" ];
      installPhase = ''

        fontDir=$out/share/fonts/truetype
        mkdir -p $fontDir
        cp $src/fonts/*.ttf $fontDir
      '';

      meta = {
        platforms = stdenv.lib.platforms.unix;
      };
    };

  all-the-icons = pkgs.callPackage all-the-icons-fn {};

in
{

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # services.xserver.desktopManager.gnome3.sessionPath = with pkgs; [ clearlooks-phenix theme-vertex ];
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

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
      unifont
      all-the-icons
    ];
  };

  environment.systemPackages = with pkgs; [
    gtk2
    gtk3
    pavucontrol
    clearlooks-phenix
    theme-vertex
    # gnome3.gnome-backgrounds
    # gnome3.gnome_control_center
    # gnome3.gnome_keyring
    # gnome3.gnome_session
    # gnome3.gnome_settings_daemon
    # gnome3.gnome_themes_standard
    mesa
    mesa_drivers
  ];

  # services.gnome3 = {
  #   at-spi2-core.enable = true;
  #   # evolution-data-server.enable = true;
  #   # gnome-documents.enable = true;
  #   gnome-keyring.enable = true;
  #   gvfs.enable = true;
  #   sushi.enable = true;
  #   tracker.enable = false;
  # };

  # services.accounts-daemon.enable = true;
  services.devmon.enable = true;
  # services.geoclue2.enable = true;
  # services.telepathy.enable = true;
  # services.udisks2.enable = true;

}
