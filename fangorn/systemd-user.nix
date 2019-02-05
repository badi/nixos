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
      description = "Window Manager";
    };
  };
  systemd.user.services =
    let
      mk-service =
      { name
      , pkg
      , bin-path ? null
      , env ? {}
      , depends-on ? []
      , wantedBy ? [ "wm.target" ]
      , enable ? true
      }:
      let
        inherit (lib) attrByPath;
        bin = if isNull bin-path then "bin/${name}" else bin-path;
        desc = attrByPath ["meta" "description"] "Description not available" pkg;
      in
      { inherit enable;
        description = "${name}: ${desc}";
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

    taffybar = {
      enable = true;
      description = "taffybar";
      serviceConfig.ExecStart = "${pkgs.taffybar}/bin/taffybar -l DEBUG";
      requires = [ "status-notifier-watcher.service" ];
      after = [ "status-notifier-watcher.service" ];
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
      # environment = {
      #   GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
      # };
    };

    status-notifier-watcher =
    let package = pkgs.haskellPackages.status-notifier-item; in
    {
      enable = true;
      description = "status-notifier-watcher: ${package.meta.description}";
      serviceConfig.ExecStart = "${package}/bin/status-notifier-watcher -l DEBUG";
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
    };
    keepassxc = {
      enable = true;
      description = "keepassxc: ${pkgs.keepassxc.meta.description}";
      serviceConfig.ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      path = [ config.system.path ];
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
      environment = {
        QT_DEBUG_PLUGINS = "1";
      };
    };
    copyq = {
      enable = true;
      description = "copyq: ${pkgs.copyq.meta.description}";
      serviceConfig.ExecStart = "${pkgs.copyq}/bin/copyq";
      path = [ config.system.path ]; # needed to get qt plugins; fails without this
      requires = [ "taffybar.service" ];
      after = [ "taffybar.service" ];
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
      environment = {
        QT_DEBUG_PLUGINS = "1";
      };
    };
    nm-applet = {
      enable = true;
      description = "nm-applet: ${pkgs.networkmanagerapplet.meta.description}";
      serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      path = [ config.system.path ];
      requires = [ "taffybar.service" ];
      after = [ "taffybar.service" ];
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
    };
    pasystray =  {
      enable = true;
      description = "pasystray: ${pkgs.pasystray.meta.description}";
      serviceConfig.ExecStart = "${pkgs.pasystray}/bin/pasystray -d";
      path = [ config.system.path ];
      requires = [ "taffybar.service" ];
      after = [ "taffybar.service" ];
      partOf = [ "wm.target" ];
      wantedBy = [ "wm.target" ];
    };
  };


}
