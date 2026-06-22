# Custom package list and system packages.
# Defines `custom.packages.system` so other modules (e.g. nix-ld) can refer to it.
{
  lib,
  pkgs,
  ...
}:

let
  topLevel = with pkgs; [
    collabora-desktop
    docker-compose
    cups
    pciutils
    usbutils
    adwaita-icon-theme
    hicolor-icon-theme
    libsForQt5.qtsvg
    qt6.qtimageformats
    qt6.qtsvg
    openssl
    qt6.qtbase
    qt6.qmake
    qt6.qttools
    qt6.qtwayland
    kdePackages.qt5compat
    graphene
    libGLX
    pkg-config
    libsoup_3
    webkitgtk_6_0
    qt6.qtwebengine
    qt6.qtmultimedia
    qt6.qtdeclarative
    qt6.qtwebchannel
    qt6.qtpositioning
    glfw
    openal
    alsa-lib
    alsa-utils
    libjack2
    libpulseaudio
    pipewire
    libGL
    libx11
    libxcursor
    libxext
    libxrandr
    libxxf86vm
    udev
    vulkan-loader
    vim
    wget
    sbctl
    stow
    nspr
    nss
    atk
    at-spi2-atk
    dbus
    expat
    gtk3
    gtk4
    harfbuzz
    libdrm
    libgbm
    libxkbcommon
    mesa
    pango
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxtst
    libxcb
    glib
    cairo
    gdk-pixbuf
    git
    curl
    wget
    vim
    zip
    unzip
    file
    killall
    tree
    wl-clipboard-rs
    dmidecode

    (pkgs.stdenvNoCC.mkDerivation {
      pname = "windows-cursor-theme";
      version = "unstable";

      src = ../assets/Windows;

      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/icons/Windows
        cp -a index.theme cursor.theme $out/share/icons/Windows/
        cp -a cursors $out/share/icons/Windows/

        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Windows-style Xcursor theme (Taken from Windows-Cursor-Concept-v2)";
        license = licenses.unfree;
        platforms = platforms.unix;
      };
    })
  ];

  devLib = import ../lib { inherit lib; };
in
{
  options.custom.packages.system = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = topLevel;
    description = "Top-level system packages available to other modules (e.g. nix-ld).";
  };

  config.environment.systemPackages = topLevel ++ devLib.devClosure topLevel;
}
