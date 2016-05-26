{ pkgs, config, ... }:

{

  boot.initrd.availableKernelModules = ["tun" "kvm-intel" "virtio"];
  virtualisation.docker.enable       = true;
  virtualisation.libvirtd.enable     = true;
  virtualisation.libvirtd.enableKVM  = true;
  environment.systemPackages         = with pkgs; [ virtmanager ];
}
