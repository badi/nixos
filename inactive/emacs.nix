{ pkgs, ... }:

{ systemd.services.emacs = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = import ./withTmuxSystemdService.nix {
      pkgs = pkgs;
      name = "emacs";
      command = "${pkgs.bash}/bin/bash -lc '${pkgs.emacs}/bin/emacs -nw'";
    };
  };
}
