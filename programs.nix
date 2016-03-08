{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  powerManagement.enable = true;
  programs.light.enable = true;
  programs.kbdlight.enable = true;
  programs.bash.enableCompletion = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
