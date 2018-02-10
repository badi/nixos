{ config, pkgs, ... }:

let
  overlay = import "${pkgs.callPackage ./nixpkgs-mozilla.nix {}}/rust-overlay.nix";
in

{

  nixpkgs.overlays = [
    (self: super: {
      rust-overlay = (overlay self super).latest;
      # inherit ((firefox-overlay self super).latest) firefox-nightly-bin;
    })
  ];

}
