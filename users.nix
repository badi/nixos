{ ... }:
{
  users.extraGroups.yubikey = {};
  users.extraUsers.badi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "yubikey" ];
    uid = 1000;
  };
}
