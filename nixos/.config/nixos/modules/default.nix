# Master module list — imports every thematic module.
# This is the single file pulled in by configuration.nix.
{ ... }: {
  imports = [
    ./packages.nix
    ./boot.nix
    ./security.nix
    ./networking.nix
    ./locale.nix
    ./fonts.nix
    ./users.nix
    ./programs.nix
    ./environment.nix
    ./hardware.nix
    ./systemd.nix
    ./services.nix
    ./nix.nix
    ./xdg.nix
    ./cachyos.nix
    ./chaotic.nix
    ./virtualization.nix
    ./documentation.nix
  ];
}
