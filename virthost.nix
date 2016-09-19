{ pkgs, config, ... }:

{

  boot.initrd.availableKernelModules = ["tun" "kvm-intel" "virtio" "vboxdrv" "vboxnetflt"];
  virtualisation.docker.enable       = true;
  virtualisation.libvirtd.enable     = true;
  virtualisation.libvirtd.enableKVM  = true;
  virtualisation.virtualbox.host.enable = true;
  environment.systemPackages         = with pkgs; [ virtmanager ];
}
