{ pkgs, ... }:

let
  # Mount options for the bind mounts
  mountOptions = [
    "ro"
    "x-gvfs-hide"
    # Resolves symlinks as if they were real files
    # Needed for things like OnlyOffice
    "resolve-symlinks"
  ];
in
{
  # Bind mounts fonts, icons and themes from
  # The /run/current-system/sw/share/* paths
  # to their /usr/share/* equivalents

  # Flatpak: Bind mounts /usr/share/* directories
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = {
    # Fonts
    "/usr/share/fonts" = {
      device = "/run/current-system/sw/share/X11/fonts";
      fsType = "fuse.bindfs";
      options = mountOptions;
    };

    # Icons
    "/usr/share/icons" = {
      device = "/run/current-system/sw/share/icons";
      fsType = "fuse.bindfs";
      options = mountOptions;
    };

    # Themes
    "/usr/share/themes" = {
      device = "/run/current-system/sw/share/themes";
      fsType = "fuse.bindfs";
      options = mountOptions;
    };
  };
}
