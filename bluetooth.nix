{pkgs, config, ...}:

{

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  nixpkgs.config.packageOverrides = pkgs: { bluez = pkgs.bluez5; };
  services.dbus.packages = [ pkgs.bluez  ];

  security.polkit.extraConfig = ''
    /* Allow users in wheel group to use blueman feature requiring root without authentication */
    polkit.addRule(function(action, subject) {
        polkit.log("ActionID: " + action.id);
        if ((action.id == "org.blueman.network.setup" ||
             action.id == "org.blueman.dhcp.client" ||
             action.id == "org.blueman.rfkill.setstate" ||
             action.id == "org.blueman.pppd.pppconnect") &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';

}
