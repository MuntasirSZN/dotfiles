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
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
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
            };
          };
        };
      };
    };
  };
}
