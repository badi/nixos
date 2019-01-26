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
}
