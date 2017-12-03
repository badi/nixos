{ config, pkgs, ... }:

let
  nixpkgs-mozilla = pkgs.fetchgit {
    url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	  sha256 = "0g1ig96a5qzppbf75qwll8jvc7af596ribhymzs4pbws5zh7mp6p";
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
