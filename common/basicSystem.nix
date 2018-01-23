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

    aria
    bind
    bmon
    curl
    dmidecode
    emacs25-nox
    file
    gitAndTools.gitFull
    hdparm
    htop
    hwdata
    inetutils
    iotop
    lshw
    lsof
    lsscsi
    mkpasswd
    nethogs
    nix-prefetch-scripts
    nix-repl
    nix-serve
    nmap
    p7zip
    pciutils
    psmisc
    pv
    rsync
    sdparm
    silver-searcher
    smartmontools
    tmux
    unrar
    unzip
    usbutils
    utillinux
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
  # security
  networking.tcpcrypt.enable = false;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # TODO security.hideProcessInformation = true;
  security.pam.enableSSHAgentAuth = true;
  security.polkit.enable = true;

  ################################################################################
  # services
  services.ntp.enable = true;
  services.smartd.enable = true;

  ################################################################################
  # system
  powerManagement.enable = true;

  time.timeZone = "US/Eastern";

}
