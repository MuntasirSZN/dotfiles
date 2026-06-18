# Programs configuration (Hyprland, dms-shell, ZSH, GPG, nix-ld, etc.).
{
  config,
  pkgs,
  ...
}:

{
  programs = {
    gamemode.enable = true;
    kdeconnect.enable = true;
    seahorse.enable = true;

    hyprland = {
      enable = true;
      withUWSM = false;
    };

    dms-shell = {
      enable = true;
      quickshell.package = pkgs.quickshell;
      enableSystemMonitoring = false;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };

    mtr.enable = true;
    zsh.enable = true;
    bash.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld = {
      enable = true;
      libraries = config.custom.packages.system;
    };
  };
}
