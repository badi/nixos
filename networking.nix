{ ... }:

{
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
  };
}
