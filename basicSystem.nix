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
  nix.gc.dates = "monthly";

  ################################################################################
  # networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  ################################################################################
  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraClientConf = ''
    extra-arguments=--log-target=syslog --dl-search-path=${pkgs.pulseaudioFull}/lib/pulse-9.0/modules
  '';
  # nixpkgs.config.packageOverrides = pkgs: { bluez = pkgs.bluez5; };
  services.dbus.packages = [ pkgs.bluez  ];

  security.polkit.extraConfig = ''
    /* Allow users in wheel group to use blueman feature requiring root without authentication */
    polkit.addRule(function(action, subject) {
        polkit.log("ActionID: " + action.id);
        if ((action.id == "org.blueman.network.setup" ||
             action.id == "org.blueman.dhcp.client" ||
             action.id == "org.blueman.rfkill.setstate" ||
             action.id == "org.blueman.pppd.pppconnect") &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';


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
