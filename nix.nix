{ ... }:
{
  nix = {
    useChroot = true;
    trustedBinaryCaches = [
      # https://hydra.cryp.to
      https://cache.nixos.org
    ];
    binaryCaches = [
      # https://hydra.cryp.to
      https://cache.nixos.org
    ];
    binaryCachePublicKeys = [ "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g=" ];
    extraOptions = ''
      binary-caches-parallel-connections = 50
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
  };

}
