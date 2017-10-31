{ ... }:

{
  services.syncthing = {
    enable = true;
    useInotify = true;
    user = "badi";
    dataDir = "/home/badi/.syncthing";
    openDefaultPorts = true;
  };

}
