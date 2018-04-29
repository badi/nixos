{ pkgs
, ...
}:

{
  services.syncthing = {
    enable = true;
    user = "badi";
    dataDir = "/home/badi/.syncthing";
    openDefaultPorts = true;
  };

  environment.systemPackages = [ pkgs.syncthing-tray ];

}
