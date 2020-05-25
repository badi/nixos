{...}:

{

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: with haskellPackages; [
      xmonad-screenshot
      xmonad-spotify
      xmonad-utils
      xmonad-volume
      # xmonad-wallpaper
      # xmonad-windownames
    ];
  };

}
