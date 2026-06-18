# Main NixOS configuration entry point.
# Imports all thematic modules and external modules.
{ inputs, ... }:

{
  imports =
    let
      # Auto-generated hardware config (disk layout, filesystems, etc.)
      base = [ ./hardware-configuration.nix ];
      # Thematic modules (boot, networking, services, etc.)
      thematic = [ ./modules ];
      # External flake modules
      external = [ inputs.cachyos-settings.nixosModules.default ];
    in
    base ++ thematic ++ external;

  # This value should never change after initial install.
  system.stateVersion = "25.11";
}
