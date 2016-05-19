{ ... }:

{
  services.udev.extraRules = with builtins;
    let rules = "https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules";
    in readFile (fetchurl rules);

  users.extraGroups.yubikey = {};
}
