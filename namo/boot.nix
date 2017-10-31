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

  fileSystems."/mandos" = {
    device = "mandos";
    fsType = "zfs";
  };

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";
  services.zfs.autoScrub.pools = [ "mandos" ];

  services.prometheus.nodeExporter.enable = true;
  services.prometheus.nodeExporter.openFirewall = true;

  users.extraGroups.mandos.gid = 1002;
  users.extraUsers.badi = {
    isNormalUser = true;
    uid = 1001;
    createHome = true;
    extraGroups = [ "wheel" "mandos"];
    initialHashedPassword = "$6$57MWbD8YW3YKQsI$UUyMnkH0k8WDJ7vOt3cgkj8XVO7QBsVeR79GyqydEFmKtqAEg1n9y853BGgzc0QksNnlrUreguWxDsYrYipQU/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0AiBoBgua3YZTBfOgQk5JLdqzoY7e9ywRU3481mV2W9PRAJpkwTJ9l2vgfMt4Pj5xLJFzhwYRlZ607blXt/3pmxjfDHhsi00iXmxpkY3OLb0Fqpzeia0ibezO+7unHjb7/EhvQHX7ZBLGSsWQxDTwRhtTQF1SSrUqej1JJ+IfT6t7o+VZMIiPPswRa1pDCymI/gk9sW2RGDZr0CpTecgAEF+94Bfu6lckYLSJzIyqGzC650oqA21ubrmN7XkbgIY3jrCl13DAOArRsSlSsRMwsp8JbrJXShLnTDNxGNY/9FvEBDr3VDuDCa/lyTwdoyqn1Ev0wwy3EiQLSNdSEJ3dw== abdulwahidc@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXOgmmh7lzXpVokYnuNuUM2TRQDliQDAzEjeGlR/88z580ktTfqFj+BLlRULc52OUaq5/wLL9fVQqQHdWv0FslgSwW9wrqKuYo3ZyazP7Qz41daqiaEH2pVLTCfiqD2qVYwbVJHPcYwY3VBLSi5HwzlcZrM+jQR1lbLUpLm0w02brFVJr393q7p6prWjcRsiItI2Nimbx7rj4uLUMydQTXTiW92QiQ3eKOIX1Zb+8hx0AMdB9jCevdVojUbQ3wTdGN0Swf2371jSzS1PqGwH0nFi1QmwPj0OFlYU/OeXMOR/usHz5v8bFjPwpL3opC2eIfnTxR84hXE1hjWraxK2C1 host:irmo contact:badi@iu.edu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvnljjiF48eoHjolTVhxrv9PiQnsjoc9mIExYPv7JZC badi.abdulwahid@adroll.com"
    ];
  };



  i18n.consoleFont = "lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [ { device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214-part1"; } ];


}
