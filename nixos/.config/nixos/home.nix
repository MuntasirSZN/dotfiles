{ pkgs, inputs, ... }:

{
  home.username = "muntasir";
  home.homeDirectory = "/home/muntasir";

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.spicetify
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
    git
    curl
    wget
    vim
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
}
