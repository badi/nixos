let
  inherit (builtins) readFile fromJSON substring;

  get-release-info = path: fromJSON (readFile path);
  release = get-release-info ./release.json;
  sha256 = let s = readFile ./release-tarball.sha256;
    in substring 0 52 s;

  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${release.rev}.tar.gz";
    inherit sha256;
  };

in nixpkgs
