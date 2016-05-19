{ pkgs, config, ... }:
{

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  services.xserver.desktopManager.gnome3.sessionPath = with pkgs; [ clearlooks-phenix theme-vertex ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  environment.systemPackages = with pkgs; [
    gtk2
    gtk3
    pavucontrol
    clearlooks-phenix
    theme-vertex
    gnome3.gnome-backgrounds
    gnome3.gnome_control_center
    gnome3.gnome_keyring
    gnome3.gnome_session
    gnome3.gnome_settings_daemon
    gnome3.gnome_themes_standard
  ];

  services.gnome3 = {
    at-spi2-core.enable = true;
    # evolution-data-server.enable = true;
    # gnome-documents.enable = true;
    gnome-keyring.enable = true;
    gvfs.enable = true;
    sushi.enable = true;
    tracker.enable = false;
  };

  services.accounts-daemon.enable = true;
  services.devmon.enable = true;
  services.geoclue2.enable = true;
  services.telepathy.enable = true;
  services.udisks2.enable = true;

}
