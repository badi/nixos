{ config, lib, pkgs, ... }:
{

  # make sure to also add the *samba* user:
  # $ smbpasswd -a badi

  services.samba = {
    enable = true;
    shares = {
      mandos = {
        path = "/mandos";
        "valid users" = "@mandos";
        writable = "yes";
        browsable = "yes";
        "inherit owner" = "yes";
        "inherit permissions" = "yes";
        "inherit acls" = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "force user" = "badi";
        "force group" = "mandos";
      };
    };
    extraConfig = ''
      guest account = nobody
      # map to guest = bad user
      bind interfaces only = yes
      interfaces = eno1 127.0.0.1
      encrypt passwords = yes
      printcap name = /dev/null
      load printers = no
      # check password script
      # passwd program
      # unix password sync
    '';
  };   

  systemd.services.samba-smbd.after = [ "zfs-mount.service" ];

}
