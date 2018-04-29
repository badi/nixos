{ config, pkgs, ... }:

let
  secrets = import ../secrets {};
in

{

  imports = [ ./hardware-configuration.nix ];

  boot.supportedFilesystems = [ "zfs" "xfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" "xfs" ];

  boot.zfs.extraPools = [ "mandos" ];
  boot.zfs.forceImportAll = false;
  boot.zfs.forceImportRoot = false;

  boot.kernelParams = [ ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    memtest86.enable = true;
    device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214-part2";
    fsType = "xfs";
  };

  # fileSystems."/mandos" = {
  #   device = "mandos";
  #   fsType = "zfs";
  # };

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";
  services.zfs.autoScrub.pools = [ "mandos" ];

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;

  users.extraGroups.mandos.gid = 1002;
  users.extraUsers.badi = {
    isNormalUser = true;
    uid = 1001;
    createHome = true;
    extraGroups = [ "wheel" "mandos"];
    initialHashedPassword = "$6$57MWbD8YW3YKQsI$UUyMnkH0k8WDJ7vOt3cgkj8XVO7QBsVeR79GyqydEFmKtqAEg1n9y853BGgzc0QksNnlrUreguWxDsYrYipQU/";
    openssh.authorizedKeys.keys =
      secrets.ssh-keys.badi.fangorn;
  };



  i18n.consoleFont = "lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [ { device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214-part1"; } ];


}
