# Virtualization (Docker) configuration.
_:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      storageDriver = "btrfs";
    };
  };
}
