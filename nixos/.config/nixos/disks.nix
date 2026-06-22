{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                device = "/dev/disk/by-uuid/2D42-8F93";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luksroot";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "tpm2-device=auto" ];
                };
                content = {
                  type = "lvm_pv";
                  vg = "nix";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      nix = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              device = "/dev/mapper/nix-root";
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:2"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:2"
                  ];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:2"
                  ];
                };
              };
            };
          };
          home = {
            size = "270G";
            content = {
              type = "btrfs";
              device = "/dev/mapper/nix-home";
              subvolumes = {
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:2"
                  ];
                };
                "@.snapshots" = {
                  mountpoint = "/home/.snapshots";
                  mountOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:2"
                  ];
                };
              };
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
              device = "/dev/mapper/nix-swap";
              # Avoid `blkid` warning on the swap LV
              discardPolicy = "once";
            };
          };
        };
      };
    };
  };
}
