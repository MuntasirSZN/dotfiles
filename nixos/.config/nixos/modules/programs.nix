# Programs configuration (Hyprland, dms-shell, ZSH, GPG, nix-ld, etc.).
{
  config,
  pkgs,
  ...
}:

{
  programs = {
    # capSysNice isnt enabled, causes failed to inherit capabilities: Operation not permitted.
    # Ananicy-cpp with cachyos-rules is enough, it nices it automatically.
    gamescope = {
      enable = true;
      enableWsi = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-vaapi
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.input-overlay
        obs-studio-plugins.obs-multi-rtmp
      ];
    };
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.icu
        ];
      };
    };
    ydotool.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      withPython3 = true;
    };
    gamemode.enable = true;
    kdeconnect.enable = true;

    hyprland = {
      enable = true;
      withUWSM = false;
    };
    dank-calendar = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };
    dms-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
    };
    dsearch = {
      enable = true;
      systemd.enable = true;
    };

    mtr.enable = true;
    fish.enable = true;
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
