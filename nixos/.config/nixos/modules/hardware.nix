# Hardware-specific options (graphics, firmware, etc.).
# Does NOT replace the auto-generated hardware-configuration.nix.
{ pkgs, ... }:

{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
    };
    enableRedistributableFirmware = true;
  };
}
