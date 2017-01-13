{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [ libu2f-host ];
  users.extraGroups.yubikey = {};
}
