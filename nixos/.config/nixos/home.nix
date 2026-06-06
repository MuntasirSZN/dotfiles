{
  pkgs,
  inputs,
  ...
}:

{
  home.username = "muntasir";
  home.homeDirectory = "/home/muntasir";

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nix-index-database.homeModules.default
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;
    extraConfig = ''
      source = main.conf
    '';
    # Change when dms uses lua (remove)
    configType = "hyprlang";
  };

  programs = {
    home-manager.enable = true;
    zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      profiles.default.sine.enable = true;
    };

    spicetify = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}; {
      enable = true;
      enabledExtensions = with extensions; [
        adblockify
        fullAppDisplayMod
      ];
      enabledCustomApps = with apps; [
        marketplace
        ncsVisualizer
      ];
      theme = themes.catppuccin;
      colorScheme = "mocha";
      wayland = true;
    };
  };
  xdg.autostart.enable = true;

  home.packages = with pkgs; [
    ghostty
    zsh
    imagemagick
    fzf
    vivid
    zed-editor
    clang
    nwg-look
    cava
    pavucontrol
    nil
    nixd
    cmake
    gnumake
    git-credential-manager
    vicinae
    matugen
    khal
    vdirsyncer
    wtype
    dgop
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    bitwarden-desktop
    bitwarden-cli
    nautilus
    nautilus-open-any-terminal
    networkmanagerapplet
    adw-gtk3
    ddcutil
    (discord.override {
      withVencord = true;
    })
    cachix
    nh
    kdePackages.kdeconnect-kde
    udisks
    amberol
    celluloid
    gnome-calculator
    thunderbird
    emacs
    doppler
    gvfs
    jmtpfs
    simple-mtpfs
    libmtp
    gnome-online-accounts-gtk
    keepassxc
    rclone-browser
    rclone
  ];
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      catppuccin-fcitx5
      fcitx5-m17n
      qt6Packages.fcitx5-configtool
    ];
  };
  systemd.user.services.rclone-google = {
    Unit = {
      Description = "Rclone Google Drive Mount";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStart = "${pkgs.rclone}/bin/rclone mount 'Google Muntasir:' %h/google --vfs-cache-mode full";
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/google";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  systemd.user.services.vdirsyncer-sync = {
    Unit = {
      Description = "Run vdirsyncer sync";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
    };
  };
  systemd.user.timers.vdirsyncer-sync = {
    Unit = {
      Description = "Run vdirsyncer sync every 5 minutes";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # Otherwise xdg-desktop-portal-gtk doesn't work
  home.file.".config/systemd/user/xdg-desktop-portal.service.d/env-override.conf".text =
    ''
    [Service]
    UnsetEnvironment=NIX_XDG_DESKTOP_PORTAL_DIR
    '';
}
