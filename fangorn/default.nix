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
in
{

  imports = [
    ./hardware-configuration.nix
    ./systemd-user.nix
    ../common/nix-config.nix
    # ./packages.nix

    ../common/basicSystem.nix
    ../common/dumb-login-shell-prompt.nix
    ../common/oh-my-zsh.nix
    ../common/desktopManager.nix
    ../common/devenv-haskell.nix
    # ../common/nvidia.nix
    ../common/users.nix
    ../common/vpn.nix
    ../common/syncthing.nix
    ../common/junk-blocker.nix

    ../modules/nextcloud
    ../modules/popfile
  ];


  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  # services.xserver.deviceSection = ''
  #   Driver "amdgpu"
  # '';


  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel vaapiVdpau libvdpau-va-gl intel-ocl
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "wireguard" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    wireguard
  ];

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      arandr
      dmenu
      dunst
      # enlightenment.terminology
      i3lock
      i3lock-fancy
      i3status
      nextcloud-client
      notify-osd
      volnoti
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDbgpcaBErGwC4jgyREUF9DMEEdxYo3/H0Zx0naZqTz NixOps client key for fangorn" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${ethernet.mac}", NAME="${ethernet.name}"
  '';

  services.openvpn.servers.streisand.autoStart = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_250GB_S1DBNSAF757040Z";

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.
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

    nilfs-utils

    aws
    alacritty
    bat
    digikam gwenview okular
    emacs
    evince
    firefox-bin
    # gimp-with-plugins
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
    masterpdfeditor
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
    terraform-full
    thunderbird
    tlaplusToolbox
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



  # security.acme.certs = {
  #   "cloud.badi.sh" = {
  #     postRun = "systemctl reload nginx.service";
  #     user = "nginx";
  #     group = "nginx";
  #   };
  # };

  # services.nextcloud = {
  #   enable = true;
  #   hostName = "cloud.badi.sh";
  #   https = false;
  #   nginx.enable = true;
  #   config.dbtype = "sqlite";
  #   config.adminuser = "root";
  #   config.adminpass = "root";
  #   config.extraTrustedDomains = [ "localhost" ];
  #   home = "/var/lib/nextcloud";
  #   webfinger = true;
  #   php.imagick.enable = true;
  # };


  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
  };
  services.nextcloud-badi = {
    enable = true;
    package = pkgs.nextcloud;
    vhosts = [ "cloud.badi.sh" "${config.networking.hostName}.badi.sh" ];
    listenAddr = "0.0.0.0";
    openFirewall = true;
    clientMaxBodySize = "1G";
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;
  nixpkgs.config.virtualbox.enableExtensionPack = false;


  services.popfile.enable = true;

  services.synergy.server.enable = false;
  services.synergy.server.configFile = "/home/badi/.synergy.conf";

  services.grafana.enable = true;
  services.grafana.addr = "0.0.0.0";

  services.prometheus.enable = true;
  services.prometheus.exporters.node.enable = true;

  services.prometheus.exporters.blackbox.enable = true;
  services.prometheus.exporters.blackbox.openFirewall = true;
  services.prometheus.exporters.blackbox.configFile = pkgs.writeTextFile {
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
        { targets = [ "fangorn:9100" ];
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
