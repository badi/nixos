{ config, pkgs, ... }:

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

  swapDevices = [ { device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214-part1"; } ];


}
