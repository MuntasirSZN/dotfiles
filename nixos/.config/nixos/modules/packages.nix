# Custom package list and system packages.
# Defines `custom.packages.system` so other modules (e.g. nix-ld) can refer to it.
{
  lib,
  pkgs,
  ...
}:

let
  topLevel = with pkgs; [
    nur.repos.ilya-fedin.qt6ct
    ffmpeg-full
    fish
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
    webkitgtk_4_1
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
    mesa
    at-spi2-atk
    dbus
    expat
    gtk3
    gtk4
    harfbuzz
    libdrm
    libgbm
    libxkbcommon
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
    psmisc
    lsof
    tree
    wl-clipboard
    dmidecode
    pv
    which
    bc
    jq
    rsync
    strace
    ltrace
    tcpdump
    netcat-openbsd
    socat
    bind.dnsutils
    whois
    htop
    iotop
    sysstat
    smartmontools
    dosfstools
    ntfs3g
    exfat
    btrfs-progs
    time
    units
    parallel
    moreutils
    expect
    dialog
    xxd
    lm_sensors
    acpi
    p7zip
    rar
    unrar
    lz4
    ethtool
    hostname
    lshw
    lsscsi
    net-tools
    nvme-cli
    patch
    sg3_utils
    squashfsTools
    man-pages
    man-pages-posix
    libsecret
    lsb-release
    # List by default
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd

    # My own additions
    libxcomposite
    libxtst
    libxrandr
    libxext
    libx11
    libxfixes
    libGL
    libva
    pipewire
    libxcb
    libxdamage
    libxshmfence
    libxxf86vm
    libelf

    # Required
    glib
    gtk2

    # Inspired by steam
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
    networkmanager
    vulkan-loader
    libgbm
    libdrm
    libxcrypt
    coreutils
    pciutils
    zenity
    # glibc_multi.bin # Seems to cause issue in ARM

    # # Without these it silently fails
    libxinerama
    libxcursor
    libxrender
    libxscrnsaver
    libxi
    libsm
    libice
    gnome2.GConf
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    ffmpeg
    # Only libraries are needed from those two
    libudev0-shim

    # needed to run unity
    gtk3
    icu
    libnotify
    gsettings-desktop-schemas
    # https://github.com/NixOS/nixpkgs/issues/72282
    # https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
    # log in /home/leo/.config/unity3d/Editor.log
    # it will segfault when opening files if you don’t do:
    # export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
    # other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed

    # Verified games requirements
    libxt
    libxmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew_1_10
    libidn
    tbb

    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    libxft
    libvdpau
    # ...
    # Some more libraries that I needed to run programs
    pango
    cairo
    atk
    gdk-pixbuf
    fontconfig
    freetype
    dbus
    alsa-lib
    expat
    # for blender
    libxkbcommon

    libxcrypt-legacy # For natron
    libGLU # For natron

    # Appimages need fuse, e.g. https://musescore.org/fr/download/musescore-x86_64.AppImage
    fuse
    e2fsprogs

    # darktable nightly AppImage https://github.com/darktable-org/darktable/releases
    gmp

    # RapidRaw
    harfbuzz
    libgpg-error
    # https://github.com/xournalpp/xournalpp/releases/download/v1.2.4/xournalpp-1.2.4-x86_64.AppImage
    fribidi
    librsvg
    # https://github.com/nix-community/nix-ld/issues/95#issuecomment-3041993870
    (runCommand "librsvg" { } ''
      mkdir -p $out/lib/gdk-pixbuf-2.0/2.10.0/loaders
      ln -s "${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader_svg.so" "$out/lib/libpixbufloader-svg.so"
    '')

    # pdfmastereditor
    sane-backends
    pkcs11helper

    # Qt6 requires this (e.g. used in zxlive)
    libpulseaudio
    krb5
    libxcb-cursor
    libxcb-wm
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util

    (pkgs.callPackage ../pkgs/windows-cursor-theme { })

    (pkgs.callPackage ../pkgs/valgrind-codspeed { })
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
