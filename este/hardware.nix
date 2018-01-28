{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B120-5479";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/393559b5-c6cd-4c52-a52e-db18e0a314cf";
      fsType = "xfs";
    };

  swapDevices = [
    { device = "/dev/disk/by-uuid/951790e3-d587-48df-a046-6a129510c033";
    }
  ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "powersave";
}
