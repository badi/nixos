{ ... }:
{
  users.extraGroups.yubikey = {};
  users.extraUsers.badi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "yubikey" ];
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };
}
