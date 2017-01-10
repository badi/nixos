{ pkgs, config, ... }:
{

  ################################################################################
  # environment
  nixpkgs.config.allowUnfree = true;
  boot.cleanTmpDir = true;

  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  environment.systemPackages = with pkgs;
       [ file htop hwdata iotop lsof lshw lsscsi nethogs pciutils psmisc which smartmontools xsettingsd usbutils bind inetutils ]
    ++ [ nix-serve nix-prefetch-git nix-prefetch-hg nix-prefetch-svn nix-prefetch-zip nix-prefetch-scripts ]
    ++ [ wget curl ]
    ++ [ vim emacs24-nox ]
    ++ [ gitAndTools.gitFull ]
    ++ [ mkpasswd ];

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  ################################################################################
  # nix configuration
  nix.useSandbox = true;
  nix.trustedBinaryCaches = [ https://cache.nixos.org ];
  nix.binaryCaches = [ https://cache.nixos.org ];
  nix.extraOptions = "binary-caches-parallel-connections = 50";
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 14d";

  ################################################################################
  # networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # environment.etc."dbus-1/system.d/bluetooth.conf".text =
  #   let
  #     inherit (builtins) writeTextFile;
  #     inherit (pkgs.lib) mkMerge singleton;
  #     bluetooth_conf = writeTextFile ''
  #     '';
  #     bluetooth_conf2 = readFile "${pkgs.bluez5}/etc/dbus-1/system.d/bluetooth.conf";
  #   in "${pkgs.bluez5}/etc/dbus-1/system.d/bluetooth.conf";

  # nixpkgs.config.packageOverrides = pkgs: { bluez = pkgs.bluez5; };
  # services.dbus.packages = [ pkgs.bluez5 ];

  ################################################################################
  # security
  networking.tcpcrypt.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  security.pam.enableOTPW = true;
  security.pam.enableSSHAgentAuth = true;
  security.pam.enableU2F = true;
  security.pam.mount.enable = true;
  security.polkit.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  ################################################################################
  # services
  services.atd.enable = false;
  services.avahi.enable = false;
  services.locate.enable = false;
  services.ntp.enable = true;
  services.smartd.enable = true;
  services.openssh.enable = true;

  ################################################################################
  # system
  powerManagement.enable = true;
  system.autoUpgrade.enable = true;

  system.stateVersion = "16.03";
  time.timeZone = "US/Eastern";

}
