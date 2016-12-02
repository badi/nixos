{ pkgs, config, ... }:

{

  # https://github.com/domenkozar/snabb-openstack-testing
  boot.kernelModules = [ "kvm-intel nested=1" "pci-stub" ];
  boot.kernelParams  = [ "intel_iommu=on" "hugepages=4096" ];

  virtualisation.docker.enable       = true;
  virtualisation.libvirtd.enable     = true;
  virtualisation.libvirtd.enableKVM  = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;
  nixpkgs.config.virtualbox.pulseSupport = true;
  environment.systemPackages         = with pkgs; [ virtmanager ];

}
