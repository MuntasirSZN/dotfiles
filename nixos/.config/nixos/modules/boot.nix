# Bootloader, kernel, initrd, plymouth & related.
{
  lib,
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      measuredBoot = {
        enable = true;
        pcrs = [
          0
          2
          4
          7
        ];
      };
      configurationLimit = 8;
      settings = {
        editor = false;
      };
      bootCounting = {
        initialTries = 3;
      };
    };

    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
      };
      timeout = 2;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 3;

    initrd = {
      verbose = false;
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
      kernelModules = [ "i915" ];
    };

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "i915.fastboot=1"
    ];

    plymouth = {
      enable = true;
      theme = "cross_hud";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "cross_hud" ];
        })
      ];
    };
  };
}
