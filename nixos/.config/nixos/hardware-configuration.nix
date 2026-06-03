{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        "luksroot" = {
          device = "/dev/disk/by-uuid/97f9237e-80d5-472c-8a9d-684fb99772f2";
          preLVM = true;
          crypttabExtraOpts = [ "tpm2-device=auto" ];
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/nix-root";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "noatime"
        "discard=async"
        "compress=zstd:2"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/nix-root";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "discard=async"
        "compress=zstd:2"
      ];
    };

    "/var/log" = {
      device = "/dev/mapper/nix-root";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "noatime"
        "discard=async"
        "compress=zstd:2"
      ];
    };

    "/.snapshots" = {
      device = "/dev/mapper/nix-root";
      fsType = "btrfs";
      options = [
        "subvol=@snapshots"
        "noatime"
        "discard=async"
        "compress=zstd:2"
      ];
    };

    "/home" = {
      device = "/dev/mapper/nix-home";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "discard=async"
        "compress=zstd:2"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2D42-8F93";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/mapper/nix-swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
