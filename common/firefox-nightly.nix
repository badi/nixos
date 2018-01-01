{ config, pkgs, ... }:

let
  nixpkgs-mozilla = pkgs.fetchgit {
    url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	  sha256 = "082a38nnwabr8ilpk7myvql0dcwyr39gw5ypqxml53z5kl0lxib5";
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
