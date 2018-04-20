{ config, lib, pkgs
, ...
}:

with builtins;
with lib;

let
  cfg = config.services.popfile;
in

{

  options.services.popfile = {
    enable = mkEnableOption "Popfile email classification service";

    package = mkOption {
      type = types.package;
      default = pkgs.popfile;
      defaultText = "pkgs.popfile";
      description = "The popfile package to use.";
    };

    dataRoot = mkOption {
      type = types.str;
      default = "/var/lib/popfile";
      description = ''
        Directory where popfile will store configuration, PID file, and data.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "popfile";
      description = ''
        Name of the user owning the popfile process and data.
        Created if needed.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "nogroup";
      description = ''
        Name of the group owning the popfile process and data. 
        Created if needed.
      '';
    };

    htmlLocal = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to accept HTTP requests from other machines.";
    };

    htmlPort = mkOption {
      type = types.int;
      default = 8080;
      description = "Port on which popfile accepts HTTP requests.";
    };

    htmlSendStats = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to send a daily report of accuracy statsitics to getpopfile.org.
      '';
    };

  };

  config = mkIf cfg.enable {
    users.extraUsers."${cfg.user}" = {
      group = cfg.group;
      description = "POPFile user";
    };
    users.extraGroups."${cfg.group}" = {};

    systemd.services.popfile = {
      description = "Popfile email classification";
      path = [ cfg.package ];
      # restartIfChanged = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };
      preStart = ''
        set -x
        if ! test -d "${cfg.dataRoot}"; then
          mkdir -p "${cfg.dataRoot}"
        fi
        chown -R ${cfg.user}:${cfg.group} "${cfg.dataRoot}"
      '';
      environment = {
        POPFILE_USER = cfg.dataRoot;
      };
      script =
        let bool2bit = predicate: if predicate then "1" else "0";
        in ''
        set -x
        cd "${cfg.dataRoot}"
        popfile.pl \
          --set config_piddir="${cfg.dataRoot}" \
          --set html_local=${bool2bit cfg.htmlLocal} \
          --set html_port=${toString cfg.htmlPort} \
          --set html_send_stats=${bool2bit cfg.htmlSendStats} \
          --set pop3_enabled=${bool2bit false} \
          --set smtp_enabled=${bool2bit false} \
          --set nntp_enabled=${bool2bit false} \
          --set xmlrpc_enabled=${bool2bit false}
      '';
    };

  };

}
