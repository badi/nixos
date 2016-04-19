{ pkgs
, kernelModules ? []
, enableLibvirt ? true
, libvirtdUsers ? []
, ... }:

let
  optional = boolean: value: if boolean then [ value ] else [];
in
{

  boot.initrd.kernelModules = kernelModules;

  virtualisation.libvirtd.enable     = enableLibvirt;
  virtualisation.libvirtd.enableKVM  = enableLibvirt;
  users.extraGroups.libvirtd.members = libvirtdUsers;
  environment.systemPackages         = with pkgs; optional  enableLibvirt virtmanager;

}
