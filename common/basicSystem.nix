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
  services.smartd.extraOptions = lib.mkDefault
    [
      "-A" "/var/log/smartd/"    # save some CSVs here
      "-s" "/var/log/smartd/"    # persist state here for devices that dont save data (eg WD)
    ];
  services.smartd.defaults.autodetected = lib.mkDefault (lib.concatStringsSep " "
    [
      # scheduled test. format is T/MM/DD/d/HH
      #
      # L: long selftest
      # S: short selftest
      # C: conveyance self test
      # O: offline immediate test
      # n: selective test: next span
      # r: selective test: redo last span
      # c: selective test: continue or redo based on last test
      #
      # here i want at 1 am:
      # L on 1st and 15th of the month
      # S weekly on Tuesday
      # c daily
      "-s" "(L/../(01|15)/./01|S/../../2/01|c/../.././01)"

      "-a"                      # turns on:
                                # -H -- check health
                                # -f -- report usage failures
                                # -t -- track PreFail and Usage attribute changes
                                # -l error -- report increases in ATA errors
                                # -l selftest -- report increases in SelfTest errors
                                # -l selftests -- report changes to SelfTest execute status
                                # -C 197 -- report nonzero values of current pending sector count
                                # -U 197 -- report nonzero values of offline pending sector count

      "-o" "on"                 # monitor offline testing
      "-S" "on"                 # enable attribute autosave
      "-n" "standby,q"          # avoid spinning up disks in low power mode
      "-W" "2,40,45"            # track temp changes >= 2deg, log changes of 40deg, alert on 45deg changes
    ]);

  ################################################################################
  # system
  powerManagement.enable = lib.mkDefault true;
  hardware.enableAllFirmware = lib.mkDefault true;

  time.timeZone = lib.mkDefault "US/Central";

}
