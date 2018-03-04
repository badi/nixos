{ ... }:

let
  secrets = import ../secrets {};
in

{
  users.extraUsers.test = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$uANNctji62$bG271HHKiDMP8bv9cOyP7OoXuFwexMQapXFmkhKMAsZ.0EM8UowCuckxNg20TQRFBvxhtL3U9s4bB7xzg0vw60";
  };

  users.extraUsers.badi = {
    isNormalUser = true;
    initialHashedPassword = "$6$.YFrPdd1$/nViiUzPHuKOUYwDd3hZdG6HVm9zUOp49cv4bJkZ/InUop97mQ8HT3l7TlCWJpbN0rL0x7weVHZlSTNl0rBA11";
    createHome = true;
    extraGroups = [ "wheel" "yubikey" "networkmanager" "docker" "libvirtd" "vboxusers" "lp" ];
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    openssh.authorizedKeys.keys =
      secrets.ssh-keys.badi.fangorn;
  };
}
