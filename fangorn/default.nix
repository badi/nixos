{ config, lib, pkgs, ... }:

# let
#   packageChoices.withChrome = true;
# in

let
  secrets = import ../secrets {};

  # https://wiki.archlinux.org/index.php/Network_configuration#Change_device_name
  ethernet = {
    name = "net0";
    mac = "4c:cc:6a:28:33:18";
  };

  pkgsUnstable = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "nixpkgs-unstable";
    sha256 = "0whwjrggjq3mfdgnli16v7scq532xh67f7j71224xp9mq4ayiz98";
  }) {};

in
{

  imports = [
    ./hardware-configuration.nix
    ../common/nix-config.nix
    # ./packages.nix

    ../common/basicSystem.nix
    ../common/dumb-login-shell-prompt.nix
    ../common/oh-my-zsh.nix
    ../common/desktopManager.nix
    # ../common/bluetooth.nix
    ../common/firefox-overlay.nix
    ../common/nvidia.nix
    ../common/users.nix
    ../common/yubikey.nix
    ../common/virthost.nix
    ../common/vpn.nix
    ../common/popfile.nix
    ../common/syncthing.nix
    ../common/junk-blocker.nix

    ../modules/nextcloud
  ];

  boot.kernelModules = [ "wireguard" ];
  boot.extraModulePackages = with pkgs.linuxPackages; [
    wireguard
  ];

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      arandr
      dmenu
      dunst
      enlightenment.terminology
      i3lock
      i3lock-fancy
      i3status
      notify-osd
      rofi
      volnoti
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${ethernet.mac}", NAME="${ethernet.name}"
  '';

  services.openvpn.servers.streisand.autoStart = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_250GB_S1DBNSAF757040Z";

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 3000 24800 111 2049 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 9000; to = 9100; } ];   #  to monkey around with

  fileSystems."/home/badi/mandos" = {
    device = "//namo/mandos";
    fsType = "cifs";
    options = [ "credentials=/var/lib/mandos/auth" "uid=badi" "gid=users" "auto"
                "x-systemd.automount"
                "x-systemd.mount-timeout=10s"
              ];
  };


  nixpkgs.config.firefox.ffmpegSupport = true;

  environment.systemPackages = with pkgs; [

    aws
    alacritty
    digikam gwenview okular
    emacs25
    evince
    firefox-overlay.firefox-bin
    gimp-with-plugins
    gnutls
    google-chrome
    graphviz
    httpie
    imagemagick
    inkscape
    inotify-tools
    jq
    keepassx-community
    keychain
    konversation
    mediainfo
    mendeley
    nixops
    okular
    pandoc
    pgadmin
    pgcli
    pinentry
    pingus
    popfile
    spotify
    terraform_0_11
    thunderbird
    weechat qweechat
    wpsoffice
    xclip
    (aspellWithDicts (dicts: with dicts; [en]))

  ];


  services.postgresql = {
    enable = true;
    package = pkgs.postgresql100;
    dataDir = "/var/lib/postgresql/10.0";
  };

  services.nginx.enable = true;
  services.nextcloud = {
    enable = true;
    package = pkgsUnstable.nextcloud;
    vhosts = ["${config.networking.hostName}.localdomain"];
    listenAddr = "0.0.0.0";
    openFirewall = true;
  };


  services.synergy.server.enable = false;
  services.synergy.server.configFile = "/home/badi/.synergy.conf";

  services.grafana.enable = true;
  services.grafana.addr = "0.0.0.0";

  services.prometheus.enable = true;
  services.prometheus.nodeExporter.enable = true;
  # services.prometheus.nodeExporter.enabledCollectors = [];

  services.prometheus.blackboxExporter.enable = true;
  services.prometheus.blackboxExporter.openFirewall = true;
  services.prometheus.blackboxExporter.configFile = pkgs.writeTextFile {
    name = "prometheus-blackbox.config";
    text = ''
      modules:
        icmp_check:
          prober: icmp
          timeout: 60s
          icmp:
            preferred_ip_protocol: ip4
    '';
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "prometheus";
      scrape_interval = "60s";
      static_configs = [
        { targets = [ "localhost:9090" ];
          labels = {};
        }
      ];
    }

    {
      job_name = "node";
      scrape_interval = "5s";
      static_configs = [
        { targets = [ "localhost:9100" ];
          labels  = { alias = "fangorn"; };
        }
        { targets = [ "namo:9100" ];
          labels  = { alias = "namo"; };
        }
        { targets = [ "glaurung:9100" ];
          labels  = { alias = "glaurung"; };
        }
        { targets = [ "este:9100" ];
          labels  = { alias = "este"; };
        }
        { targets = [ "fea:9100" ];
          labels  = { alias = "fea"; };
        }
        { targets = [ "fea:9101" ];
          labels  = { alias = "unifi"; };
        }
      ];
    }

    {
      job_name = "blackbox";
      scrape_interval = "60s";
      metrics_path = "/probe";
      params = { module = [ "icmp_check" ]; };
      static_configs = [
        { targets = [ "192.168.100.1" ];
          labels = { network = "internal"; what = "modem"; };
        }
        { targets = [ "namo" "glaurung" "fangorn" "fea" ];
          labels  = { network = "internal"; };
        }
        { targets = [ "google.com" "amazon.com" "spotify.com" "comcast.com" ];
          labels = { network = "external"; };
        }
      ];
      relabel_configs = [
        { source_labels = [ "__address__" ];
          target_label  = "__param_target";
        }
        { source_labels = [ "__param_target" ];
          target_label  = "instance";
        }
        { target_label  = "__address__";
          replacement   = "127.0.0.1:9115";
          source_labels = [];
        }
      ];
    }

  ];

  system.stateVersion = "16.03";

}
