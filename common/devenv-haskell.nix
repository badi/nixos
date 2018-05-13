{ pkgs, ...}:

{
  environment.systemPackages = with pkgs.haskellPackages; [
    cabal-install
    cabal2nix
    stack
  ];

}
