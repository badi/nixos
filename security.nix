{ ... }:
{
  security.pam = {
    enableOTPW = true;
    enableSSHAgentAuth = true;
    enableU2F = true;
    mount.enable = true;
  };
  security.polkit.enable = true;
  security.rngd.enable = true;
}
