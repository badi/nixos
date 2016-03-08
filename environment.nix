{ config, pkgs, ... }:
{
  environment.variables = {
    HOST = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  environment.systemPackages = with pkgs; [
    file lsof psmisc which hwdata iotop lshw
    wget curl
    vim emacs24-nox
    gitAndTools.gitFull
    xscreensaver
  ];
}
