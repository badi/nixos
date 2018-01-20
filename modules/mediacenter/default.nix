{ ... }:

{

  imports = [
    ./unified-remote/service.nix
  ];

  nixpkgs.overlays = [
    (self: super: { unified-remote = super.callPackage ./unified-remote/package.nix {}; })
  ];

}
