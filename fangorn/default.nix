{ config, lib, pkgs, ... }:

# let
#   packageChoices.withChrome = true;
# in

let
  secrets = import ../secrets.nix {};

  # https://wiki.archlinux.org/index.php/Network_configuration#Change_device_name
  ethernet = {
    name = "net0";
    mac = "4c:cc:6a:28:33:18";
  };
in

{

  imports = [
    ./hardware-configuration.nix
    ../common/nix-config.nix
    # ./packages.nix

    ../common/basicSystem.nix
    ../common/desktopManager.nix
    ../common/auto-upgrade.nix
    # ../common/bluetooth.nix
    ../common/firefox-overlay.nix
    ../common/nvidia.nix
    ../common/users.nix
    ../common/yubikey.nix
    ../common/virthost.nix
    ../common/vpn.nix
    ../common/popfile.nix
    ../common/syncthing.nix
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${ethernet.mac}", NAME="${ethernet.name}"
  '';


  services.openvpn.servers.nordvpn.autoStart = false;

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
    device = "//10.0.0.2/mandos";
    fsType = "cifs";
    options = [ "credentials=/var/lib/mandos/auth" "uid=badi" "gid=users" "auto"
                "x-systemd.automount"
                "x-systemd.mount-timeout=10s"
              ];
  };


  nixpkgs.config.firefox.ffmpegSupport = true;

  environment.systemPackages = with pkgs; [

    aspell
    aspellDicts.en
    aws
    digikam gwenview okular
    emacs25
    evince
    firefox-overlay.firefox-nightly-bin
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
    wpsoffice
    xclip

  ];


  services.postgresql = {
    enable = true;
    package = pkgs.postgresql100;
    dataDir = "/var/lib/postgresql/10.0";
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
        { targets = [ "10.0.0.2:9100" ];
          labels  = { alias = "namo"; };
        }
        { targets = [ "10.0.0.10:9100" ];
          labels  = { alias = "glaurung"; };
        }
        { targets = [ "fea.badi.sh:9100" ];
          labels  = { alias = "fea"; };
        }
        { targets = [ "fea.badi.sh:9101" ];
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
        { targets = [ "10.0.0.1" "10.0.0.2" "10.0.0.10" "fangorn.badi.sh" "fea.badi.sh" ];
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

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = secrets.namecheap.username;
    password = "'${secrets.namecheap.password}'";
    domain = "fangorn";
  };


  system.stateVersion = "16.03";

}
