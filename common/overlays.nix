{ ... }:

{
  nixpkgs.overlays = [
    (final: previous: with final.callPackage ./emacs.nix {};
      { inherit my-emacs-with-packages; }
    )
  ];

}
