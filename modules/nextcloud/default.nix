# Owncloud service
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextcloud;
in
{
  options.services.nextcloud = {
    enable = mkEnableOption "Nextcloud instance";

    package = mkOption {
      type = types.package;
      default = pkgs.nextcloud;
      defaultText = "pkgs.nextcloud";
      description = "Nextcloud package to use.";
    };

    userinfo = mkOption {
      type = types.attrs;
      default = {
        user = "nginx";
        group = "nginx";
      };
    };

    listenAddr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Sets the nginx virthost listen address.";
    };

    listenPort = mkOption {
      type = types.int;
      default = 80;
      description = "Sets the nginx virthost listen port.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Allow traffic through the firewall on the listenPort.
        Required if access is desired from non-localhost devices.
      '';
    };

    loggingTargets = mkOption {
      type = types.attrs;
      default = {
        phpfpm = "syslog";
        phpfpmSyslogIdent = "nextcloud-phpfpm";
      };
    };

    vhosts = mkOption {
      type = types.listOf types.str;
      default = [ "cloud.${config.networking.hostname}" ];
    };

    enableSSL = mkOption {
      type = types.bool;
      default = true;
    };

    installPrefix = mkOption {
      type = types.path;
      default = "/var/www/nextcloud";
      description = ''
        Where to install Nextcloud. By default, user files will be placed in
        the data/ directory below the <option>installPrefix</option> directory.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/www/nextcloud/data";
      description = ''
        FIXME
      '';
    };

    clientMaxBodySize = mkOption {
      type = types.str;
      default = "512M";
      description = ''
        FIXME
      '';
    };

  };

  config = mkMerge [
    (mkIf (cfg.userinfo.user != "nginx") {
      users.extraUsers."${cfg.userinfo.user}" = {
        group = cfg.userinfo.user;
        description = "Nextcloud server user";
      };
      users.extraGroups."${cfg.userinfo.group}".members = [ cfg.userinfo.user ];
    })

    (mkIf cfg.enable {
      services.phpfpm.extraConfig = concatStringsSep "\n" [
        "error_log = ${cfg.loggingTargets.phpfpm}"
      ]
      ;

      services.phpfpm.pools.nextcloud = {
        listen = "/run/nextcloud.socket";
        extraConfig = concatStringsSep "\n" [
          ''
            listen.owner = ${cfg.userinfo.user}
            listen.group = nginx
            user = ${cfg.userinfo.user}
            group = ${cfg.userinfo.group}
            pm = dynamic
            pm.max_children = 75;
            pm.start_servers = 10
            pm.min_spare_servers = 5
            pm.max_spare_servers = 20
            pm.max_requests = 500
          ''

        ]
        # ++ optional (cfg.loggingTargets.phpfpm == "syslog") ''
        #   syslog.facility = ${cfg.loggingTargets.phpfpmSyslogIdent}
        # ''
        ;

      };

      systemd.services.phpfpm-nextcloud.preStart =''
        echo "Setting up Nextcloud in ${cfg.installPrefix}/"
        set -ex
        test -f ${cfg.installPrefix}/.nixos-init \
          || ${pkgs.rsync}/bin/rsync -a --checksum "${cfg.package}"/ "${cfg.installPrefix}"/
        mkdir -p "${cfg.dataDir}"
        chown -R ${cfg.userinfo.user}:${cfg.userinfo.group} "${cfg.installPrefix}"
        chown -R ${cfg.userinfo.user}:${cfg.userinfo.group} "${cfg.dataDir}"
        chmod 755 "${cfg.installPrefix}"
        chmod 700 "${cfg.dataDir}"
        chmod 750 "${cfg.installPrefix}/apps"
        chmod 700 "${cfg.installPrefix}/config"
        touch ${cfg.installPrefix}/.nixos-init
        set +x
      '';


      services.nginx = {
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "${builtins.head cfg.vhosts}" = {
            # addSSL = cfg.enableSSL;
            forceSSL = cfg.enableSSL;
            enableACME = cfg.enableSSL;
            root = cfg.installPrefix;
            serverAliases = builtins.tail cfg.vhosts;

            listen = [
              { addr = cfg.listenAddr;
                port = cfg.listenPort;
              }
            ]
            ++ optional cfg.enableSSL {
              addr = cfg.listenAddr;
              port = 443;
              ssl = true;
            }
            ;

            locations."/robots.txt" = {
              extraConfig = ''
                allow all;
                log_not_found off;
                access_log off;
              '';
            };

            extraConfig = ''
              add_header X-Content-Type-Options nosniff;
              add_header X-XSS-Protection "1; mode=block";
              add_header X-Robots-Tag none;
              add_header X-Download-Options noopen;
              add_header X-Permitted-Cross-Domain-Policies none;

              location = /.well-known/carddav {
                return 301 $scheme://$host/remote.php/dav;
              }
              location = /.well-known/caldav {
                return 301 $scheme://$host/remote.php/dav;
              }

              # set max upload size
              client_max_body_size ${cfg.clientMaxBodySize};
              fastcgi_buffers 64 4K;

              location / {
                rewrite ^ /index.php$uri;
              }


              location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
                  deny all;
              }

              location ~ ^/(?:\.(?!well-known)|autotest|occ|issue|indie|db_|console) {
                  deny all;
              }
          
              location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+)\.php(?:$|/) {
                  fastcgi_split_path_info ^(.+\.php)(/.*)$;
                  include ${pkgs.nginx}/conf/fastcgi_params;
                  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                  fastcgi_param PATH_INFO $fastcgi_path_info;
                  fastcgi_param HTTPS on;
                  #Avoid sending the security headers twice
                  fastcgi_param modHeadersAvailable true;
                  fastcgi_param front_controller_active true;
                  fastcgi_pass unix:${config.services.phpfpm.pools.nextcloud.listen};
                  fastcgi_intercept_errors on;
                  fastcgi_request_buffering off;
              }
          
              location ~ ^/(?:updater|ocs-provider)(?:$|/) {
                  try_files $uri/ =404;
                  index index.php;
              }
          
              # Adding the cache control header for js and css files
              # Make sure it is BELOW the PHP block
              location ~ \.(?:css|js|woff|svg|gif)$ {
                  try_files $uri /index.php$uri$is_args$args;
                  add_header Cache-Control "public, max-age=15778463";
                  # Add headers to serve security related headers (It is intended to
                  # have those duplicated to the ones above)
                  # Before enabling Strict-Transport-Security headers please read into
                  # this topic first.
                  # add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
                  #
                  # WARNING: Only add the preload option once you read about
                  # the consequences in https://hstspreload.org/. This option
                  # will add the domain to a hardcoded list that is shipped
                  # in all major browsers and getting removed from this list
                  # could take several months.
                  add_header X-Content-Type-Options nosniff;
                  add_header X-XSS-Protection "1; mode=block";
                  add_header X-Robots-Tag none;
                  add_header X-Download-Options noopen;
                  add_header X-Permitted-Cross-Domain-Policies none;
                  # Optional: Don't log access to assets
                  access_log off;
              }
          
              location ~ \.(?:png|html|ttf|ico|jpg|jpeg)$ {
                  try_files $uri /index.php$uri$is_args$args;
                  # Optional: Don't log access to other assets
                  access_log off;
              }


          '';

          };

        };
      };
    })


    (mkIf cfg.openFirewall {
      networking.firewall.allowedTCPPorts =
        [ cfg.listenPort ]
        ++ optional cfg.enableSSL 443
        ;
    })


  ];
}
