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

  systemd.user.services = {
    parcellite = {
      enable = true;
      description = "Parcellite: ${pkgs.parcellite.meta.description}";
      serviceConfig = {
        ExecStart = "${pkgs.parcellite}/bin/parcellite";
      };
    };
  };


}
