{ pkgs, ... }:

{ systemd.services.popfile = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = import ./withTmuxSystemdService.nix {
      pkgs = pkgs;
      name = "popfile";
      command = "${pkgs.popfile}/bin/popfile.pl";
    };
  };
}
