{ ... }:

let
  binary-caches = [
    https://cache.nixos.org
  ];

in

{


  nixpkgs.config.allowUnfree = true;

  nix.useSandbox = true;
  nix.trustedBinaryCaches = binary-caches;
  nix.binaryCaches = binary-caches;
  nix.extraOptions = "binary-caches-parallel-connections = 50";
  nix.gc.automatic = true;
  nix.gc.dates = "monthly";
  nix.gc.options = "--delete-older-than 90d";
  nix.optimise.automatic = true;
  # FIXME nix.optimise.dates = "weekly";


}
