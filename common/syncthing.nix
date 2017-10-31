{ ... }:

{
  services.syncthing = {
    enable = true;
    useInotify = true;
    user = "badi";
    dataDir = "/home/badi/.syncthing";
  };
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 ];
}
