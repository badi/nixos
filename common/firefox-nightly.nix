{ config, pkgs, ... }:

let
  nixpkgs-mozilla = pkgs.fetchgit {
    url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	  sha256 = "1lim10a674621zayz90nhwiynlakxry8fyz1x209g9bdm38zy3av";
  };

  firefox-overlay = import "${nixpkgs-mozilla}/firefox-overlay.nix";

in

{

  nixpkgs.overlays = [
    (self: super: {
      inherit ((firefox-overlay self super).latest) firefox-nightly-bin;
    })
  ];


  environment.systemPackages = with pkgs; [
    firefox-nightly-bin
  ];

}
