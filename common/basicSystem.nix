{ pkgs, config, ... }:
{

  imports = [
    ./nix-config.nix
    ./openssh.nix
  ];

  ################################################################################
  # environment
  boot.cleanTmpDir = true;

  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  environment.systemPackages = with pkgs; [

    bind
    curl
    emacs25-nox
    file
    gitAndTools.gitFull
    htop
    hwdata
    inetutils
    iotop
    lshw
    lsof
    lsscsi
    mkpasswd
    nethogs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-scripts
    nix-prefetch-svn
    nix-serve
    pciutils
    psmisc
    smartmontools
    usbutils
    vim
    wget
    which
    xsettingsd

  ];

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  ################################################################################
  # networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  ################################################################################
  # security
  networking.tcpcrypt.enable = false;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # TODO security.hideProcessInformation = true;
  security.pam.enableSSHAgentAuth = true;
  security.polkit.enable = true;

  ################################################################################
  # services
  services.atd.enable = false;
  services.avahi.enable = false;
  services.locate.enable = false;
  services.ntp.enable = true;
  services.smartd.enable = true;

  ################################################################################
  # system
  powerManagement.enable = true;
  system.autoUpgrade.enable = true;

  system.stateVersion = "16.03";
  time.timeZone = "US/Eastern";

}
