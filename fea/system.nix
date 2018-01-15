{ pkgs, ... }:
{

  imports = [
    ../common/nix-config.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-MT-64_087081950063";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    emacs
    pv
    tmux
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINddUe+ma6S0Y27La0wGd5JVSiVwiza4Xal5dtYub0x0 badi@fangorn"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvnljjiF48eoHjolTVhxrv9PiQnsjoc9mIExYPv7JZC badi@tolu"
    ];
  };

  time.timeZone = "US/Eastern";

}
