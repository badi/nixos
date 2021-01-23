{ pkgs, ... }:

let
  secrets = pkgs.callPackage ../secrets {};
in

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
    tailscale
    tmux
  ];

  users.users.root = {
    openssh.authorizedKeys.keys =
      secrets.ssh-keys.badi.fangorn;
  };

  services.tailscale.enable = true;

  services.prometheus.exporters.node.enable = false;
  services.prometheus.exporters.node.openFirewall = true;

  sound.enable = false;

  time.timeZone = "US/Central";

}
