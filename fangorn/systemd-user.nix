{config, lib, pkgs, options, modulesPath}:

{
  services.emacs.enable = true;
  services.xserver.xrandrHeads =
    let
      monitor1 = "DVI-D-0";
      monitor2 = "HDMI-A-0";
    in [
    { output = monitor1;
      primary = true;
    }
    { output = monitor2;
      monitorConfig = ''
        Option "RightOf" "${monitor1}"
      '';
    }
  ];

  services.compton = {
    enable = true;
    backend = "glx";
    shadow = true;
    vSync = "opengl-mswc";
    fade = true;
    fadeDelta = 3;
    extraOptions = ''
      xrender-sync = true
    '';
  };

  systemd.user.targets = {
    wm = {
      enable = true;
      description = "Window Manager";
      unitConfig = {
        AllowIsolate = "yes";
      };
    };
  };
  systemd.user.services =
    let
      mk-service = {name, pkg, bin-path ? null, env ? {}, depends-on ? [], wantedBy ? [ "wm.target" ]}:
      let
        bin = if isNull bin-path then "bin/${name}" else bin-path;
      in
      { enable = true;
        description = "${name}";
        serviceConfig = {
          ExecStart = "${pkg}/${bin}";
        };
        unitConfig = {
          Wants = depends-on;
          After = depends-on;
        };
        inherit wantedBy;
        environment = env;
      };
    in
  {
    taffybar = mk-service {
      name = "taffybar";
      pkg = pkgs.taffybar;
      depends-on = [ "status-notifier-watcher.service" ];
      env = {
        GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
      };
    };
    status-notifier-watcher = mk-service {
      name = "status-notifier-watcher";
      pkg = pkgs.haskellPackages.status-notifier-item;
    };
    parcellite = mk-service {
      name = "parcellite";
      pkg = pkgs.parcellite;
      depends-on = [ "taffybar.service" ];
    };
    nm-applet = mk-service {
      name = "nm-applet";
      pkg = pkgs.networkmanagerapplet;
      depends-on = [ "taffybar.service" ];
    };
    pa-applet = mk-service {
      name = "pa-applet";
      pkg = pkgs.pa_applet;
      depends-on = [ "taffybar.service" ];
    };
  };


}
