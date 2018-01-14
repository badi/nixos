{ config, pkgs, ... }:

let
  nixpkgs-mozilla = pkgs.fetchgit {
    url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	  sha256 = "082a38nnwabr8ilpk7myvql0dcwyr39gw5ypqxml53z5kl0lxib5";
  };

  overlay = import "${nixpkgs-mozilla}/firefox-overlay.nix";

in

{

  nixpkgs.overlays = [
    (self: super: {
      firefox-overlay = (overlay self super).latest;
      # inherit ((firefox-overlay self super).latest) firefox-nightly-bin;
    })
  ];


  environment.systemPackages = with pkgs; [
    firefox-overlay.firefox-nightly-bin
  ];

}
