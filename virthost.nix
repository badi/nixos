{ pkgs, config, ... }:

{

  boot.initrd.availableKernelModules = ["tun" "kvm-intel" "virtio"];
  virtualisation.libvirtd.enable     = true;
  virtualisation.libvirtd.enableKVM  = true;
  environment.systemPackages         = with pkgs; [ virtmanager ];
}
