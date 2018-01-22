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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXsB3Il+L+UfgV/GSXNCz5ALd+Ou7oIy/gF3gb0rdHIfUlmaewmIYnCFygVVXXQpj+ttCsLN6E5/Hdvd8oqBUThCN6k/LpbMkxgpypauPvgYS8Ng+L7KBTSCXjAbZ1MuWRsifRyI8+6p/bvSXHd4KuGr8KssooN0qGf2JdaC/yI1fieF5RIREiLt3gknHVzAsDjcLwvGxn9tUeeavRymAxFUDxH6hgiMFNgLaMRQqHvEiqo0nZZCJyrLR5D5ipvZcczfENJwuTKR3JJKF8junDBBhibBpneNYwlc/C2zDfappxaehw8cJ8z7D5lvme0PwjR/Ox/fBXaJ+B3Rjk/mTkWo+haI/s/ZhgjH6Ic9n8CdF3el4MzYH/OCtytl1/NP/pyhAaNMacAp30x7pjIhGzoJTvVk6PjTfezGa9CYlfJw4vdDaFJHM2gK2IWUGJ4b+izherD3dIB/nAhoWjJyraEMQe0fZEv/xdXM2Uwvb8z+shbUI5DTFD5S8cRCLe5095lZKE4KjRA9+REQSpmaSjJmK2opp2bAEGRyC5l28wIgv0FCm/YpvcDsA+bam2FK3vN9vl7B8hSVAqLSENqYm7ldYndi4iiXqB3n+qdYZ1DNcWC6V5ILXXdyZOY07WY9m87D2LCi5AfKJqnmHcMvUYxZU6XYBRSo/iH5o7rN0y5Q== badi@este.badi.sh"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvnljjiF48eoHjolTVhxrv9PiQnsjoc9mIExYPv7JZC badi.abdulwahid@adroll.com"
    ];
  };



  i18n.consoleFont = "lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [ { device = "/dev/disk/by-id/ata-WDC_WD1001FALS-00J7B1_WD-WMATV1264214-part1"; } ];


}
