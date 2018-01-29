{ config, pkgs, ... }:

let
  nixpkgs-mozilla = pkgs.fetchgit {
    url = "git://github.com/mozilla/nixpkgs-mozilla.git";
	  sha256 = "1r2jglgl9k881byv1kc3rdda2lzaarvb0xn7nx3q0b3h25apjff5";
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

}
