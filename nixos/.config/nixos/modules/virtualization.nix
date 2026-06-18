# Virtualisation (Docker) configuration.
{ ... }:

{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}
