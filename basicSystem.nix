{
  pkgs,
  config,

  cleanTmpDir ? true,
  isLaptop ? false,
  timeZone ? "US/Eastern",
  withDesktop ? true,
  usePulseAudio ? true,
  withYubikey ? true,
  withX11 ? true,
  ...
}:

let inherit (builtins) hasAttr getAttr;
    optionalAttrs = cond: set: if cond then set else {};
    optional = cond: val: if cond then [val] else [];
    isEnabled = set: if hasAttr "enable" set then true else false;
    checkEnabled = set: key: optionalAttrs (isEnabled set) (getAttr key set);
    checkEnabledConfig = set: checkEnabled set "config";
in

{

  imports = optional withYubikey ./hardware/yubico/yubikey.nix;


  hardware.pulseaudio.enable = usePulseAudio;
  powerManagement.enable = true;
  boot.cleanTmpDir = cleanTmpDir;


  nixpkgs.config.allowUnfree = true;
  programs.light.enable = isLaptop;
  programs.kbdlight.enable = isLaptop;
  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  environment.systemPackages = with pkgs;
       [ file htop hwdata iotop lsof lshw nethogs psmisc which ]
    ++ [ wget curl httpie ]
    ++ [ vim emacs24-nox ]
    ++ optional withX11 xscreensaver;

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  fonts = optionalAttrs withX11 {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      bakoma_ttf
      corefonts
      dejavu_fonts
      gentium
      inconsolata
      liberation_ttf
      terminus_font
      ubuntu_font_family
    ];
  };

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";


  nix.useChroot = true;
  nix.trustedBinaryCaches = [ https://cache.nixos.org ];
  nix.binaryCaches = [ https://cache.nixos.org ];
  nix.binaryCachePublicKeys = [ "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g=" ];
  nix.extraOptions = "binary-caches-parallel-connections = 50";
  nix.gc.automatic = true;
  nix.gc.dates = "monthly";


  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;


  security.pam.enableOTPW = true;
  security.pam.enableSSHAgentAuth = true;
  security.pam.enableU2F = true;
  security.pam.mount.enable = true;
  security.polkit.enable = true;
  security.rngd.enable = true;


  services.atd.enable = true;
  services.avahi.enable = false;
  services.locate.enable = false;
  services.ntp.enable = true;
  services.printing.enable = true;
  services.smartd.enable = true;
  services.upower.enable = true;
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.xserver.enable = withX11;

  system.autoUpgrade.enable = true;
  system.stateVersion = "16.03";
  time.timeZone = timeZone;


  # users.extraGroups = {};
  #   // optionalAttrs withYubikey {yubikey={};}

  users.extrausers.badi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" ] ++ optional withYubikey "yubikey";
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };


  zramSwap.enable = true;
  zramSwap.memoryPercent = 20;

}

// optionalAttrs withYubikey { users.extraGroups.yubikey = {}; }
