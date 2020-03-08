{ pkgs, lib, config, ... }:
{

  imports = [
    ./nix-config.nix
    ./openssh.nix
  ];

  ################################################################################
  # environment
  boot.cleanTmpDir = lib.mkDefault true;

  programs.bash.enableCompletion = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.enableCompletion = lib.mkDefault true;

  environment.systemPackages = with pkgs; [

    aria
    bc
    bind
    bmon
    colordiff
    curl
    direnv
    dmidecode
    dos2unix
    emacs26-nox
    file
    gitAndTools.git-crypt
    gitAndTools.git-extras
    gitAndTools.gitFull
    gnupg
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
    nix-serve
    nmap
    p7zip
    pciutils
    psmisc
    pv
    ripgrep
    rsync
    sdparm
    silver-searcher
    smartmontools
    speedtest-cli
    tmux
    tree
    unison
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

  networking.domain = "badi.sh";

  ################################################################################
  # security
  networking.tcpcrypt.enable = lib.mkDefault false;
  networking.firewall.enable = lib.mkDefault true;
  networking.firewall.allowPing = lib.mkDefault true;


  # TODO security.hideProcessInformation = lib.mkDefault true;
  security.pam.enableSSHAgentAuth = lib.mkDefault true;
  security.polkit.enable = lib.mkDefault true;

  ################################################################################
  # services
  networking.networkmanager.enable = true;
  services.ntp.enable = lib.mkDefault true;
  services.smartd.enable = lib.mkDefault true;
  services.smartd.notifications.mail.recipient = "admin@badi.sh";

  ################################################################################
  # system
  powerManagement.enable = lib.mkDefault true;
  hardware.enableAllFirmware = lib.mkDefault true;

  time.timeZone = lib.mkDefault "US/Central";

}
