{ ... }:
{

  services.atd.enable = true;
  services.avahi.enable = true;
  services.locate.enable = true;
  services.ntp.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
  services.printing.enable = true;
  services.smartd.enable = true;
  services.upower.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

}
