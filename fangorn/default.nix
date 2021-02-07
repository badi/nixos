{ config, lib, pkgs, ... }@args:

# let
#   packageChoices.withChrome = true;
# in

let
  secrets = pkgs.callPackage ../secrets {};

  pkgs-unstable = import (import ../nixpkgs/unstable) {};

  # https://wiki.archlinux.org/index.php/Network_configuration#Change_device_name
  ethernet = {
    name = "net0";
    mac = "4c:cc:6a:28:33:18";
  };
in
{

  imports = [
    ./hardware-configuration.nix
    # ./systemd-user.nix
    ../common/nix-config.nix
    # ./packages.nix

    ../common/basicSystem.nix
    ../common/can-sendmail.nix
    ../common/dumb-login-shell-prompt.nix
    ../common/oh-my-zsh.nix
    ../common/desktopManager.nix
    ../common/desktopManagerXmonad.nix
    ../common/desktopManagerGnome3.nix
    ../common/users.nix
    ../common/vpn.nix
    ../common/syncthing.nix
    # ../common/junk-blocker.nix

    # ../modules/nextcloud
    ../modules/popfile
  ];


  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"            # https://github.com/NixOS/nixpkgs/pull/80746
  ];

  # nixpkgs.overlays = [

  #   # for nixos 20.03
  #   # openssl-1.0.2u is insecure (support ended in 2019)
  #   (self: super: { openssl_1_0_2 = super.openssl; })

  # ];

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  hardware.opengl.driSupport32Bit = true;

  services.xserver.displayManager.gdm.wayland = false;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel vaapiVdpau libvdpau-va-gl intel-ocl
  ];

  boot.kernelPackages = pkgs.linuxPackages;


  programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.pinentryFlavor = "emacs";

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDbgpcaBErGwC4jgyREUF9DMEEdxYo3/H0Zx0naZqTz NixOps client key for fangorn" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${ethernet.mac}", NAME="${ethernet.name}"
  '';

  services.openvpn.servers.expressvpn.autoStart = false;

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [ 139 445 3000 24800 111 2049 ];
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
    appimage-run
    bat
    digikam gwenview okular
    emacsGit
    evince
    firefox-beta-bin
    # gimp-with-plugins
    gnutls
    google-chrome
    graphviz
    httpie
    imagemagick
    inkscape
    inotify-tools
    jq
    # keepassx-community
    keychain
    konversation
    mediainfo
    # mendeley  # 2020-08-29 nixpkgs-unstable broken
    nixops
    okular
    pandoc
    # pgadmin
    pgcli
    pinentry
    # pingus 19.03
    popfile
    slack
    spaceship-prompt
    spotify
    tailscale
    # terraform-full
    tlaplusToolbox
    weechat
    # qweechat 19.03
    # wpsoffice 19.03 (really wps updated and the previous is not available)
    (vivaldi.override{proprietaryCodecs=true; enableWidevine=true;})
    xclip
    zoom-us
    (aspellWithDicts (dicts: with dicts; [en]))

  ];




  services.postgresql = {
    enable = false;               # 2020-08-29 nixpkgs-unstable broken
    package = pkgs.postgresql_10; # 19.03
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

  # services.nextcloud-badi = {
  #   enable = true;
  #   package = pkgs.nextcloud;
  #   vhosts = [ "cloud.badi.sh" "${config.networking.hostName}.badi.sh" ];
  #   listenAddr = "0.0.0.0";
  #   openFirewall = true;
  #   clientMaxBodySize = "1G";
  # };

  services.popfile.enable = false;

  services.tailscale.enable = true;

  services.synergy.server.enable = false;
  services.synergy.server.configFile = "/home/badi/.synergy.conf";

  services.grafana.enable = true;
  services.grafana.addr = "0.0.0.0";

  services.prometheus.enable = true;
  services.prometheus.exporters.node.enable = true;

  services.smartd.notifications.mail.enable = true;

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
        { targets = [ "unifi:9101" ];
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
        { targets = [ "192.168.1.1" ];
          labels = { network = "internal"; what = "modem"; };
        }
        { targets = [ "namo" "glaurung" "fangorn" "unifi" ];
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
