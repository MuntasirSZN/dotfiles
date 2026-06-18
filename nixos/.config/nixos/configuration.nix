{
  pkgs,
  inputs,
  lib,
  devClosure,
  ...
}:

let
  topLevel = with pkgs; [
    docker-compose
    cups
    pciutils
    usbutils
    flite
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
    jdk25
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
    udev
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

      src = ./assets/Windows;

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
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.cachyos-settings.nixosModules.default
  ];
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

  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
  };
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networkmanager.dns = "none";
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  time.timeZone = "Asia/Dhaka";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "bn_BD/UTF-8" ];
  };
  console = {
    useXkbConfig = true;
    earlySetup = true;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (pkgs.stdenvNoCC.mkDerivation {
        pname = "bijoy-fonts";
        version = "latest";

        src = pkgs.fetchFromGitHub {
          owner = "nazdridoy";
          repo = "bijoyLinux";

          rev = "main";
          hash = "sha256-/8vu0gpcu1BEHif/UWwAc1YxcuuEtQ0NQUdP8GcWE+w=";
        };

        installPhase = ''
          mkdir -p $out/share/fonts/truetype

          find . \
            \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc" \) \
            -exec cp {} $out/share/fonts/truetype/ \; || true
        '';
      })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
      roboto
      symbola
      jetbrains-mono
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      geist-font
      rubik
      nerd-fonts.ubuntu
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  users.users.muntasir = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "docker"
    ];
    shell = pkgs.zsh;
  };
  environment.systemPackages = topLevel ++ devClosure topLevel;

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
      libraries = topLevel;
    };
  };
  environment.variables = {
    CC = "clang";
    CXX = "clang++";
    # qt-build-utils only includes module directories under qtbase's prefix.
    # On NixOS each Qt module lives in a separate store path, so modules
    # like Multimedia and WebEngine are missed. Add their include dirs
    # explicitly so cc-rs passes them to the C++ compiler.
    # qt-build-utils's include_paths constructs ${QT_INSTALL_HEADERS}/Qt{module}
    # for each module. For modules in qtbase (Core, Gui, Widgets, etc.) these
    # exist under qtbase's own include dir. For modules in separate Nix store
    # paths (Multimedia, WebEngine) they don't, so the headers are never added.
    # The forwarding headers (<QMediaPlayer>, <QWebEngineHistory>) then pull
    # in sub-includes with module-qualified paths like <QtMultimedia/foo.h> or
    # <QtWebEngineCore/foo.h>. Provide both the module subdirectory (for the
    # forwarding header itself) and the base include dir (for the qualified
    # includes inside it).
    CXXFLAGS = lib.concatStringsSep " " [
      # Module subdirectories — for bare includes like <QMediaPlayer>
      "-I${pkgs.qt6.qtmultimedia}/include/QtMultimedia"
      "-I${pkgs.qt6.qtmultimedia}/include/QtMultimediaWidgets"
      "-I${pkgs.qt6.qtwebengine}/include/QtWebEngineCore"
      "-I${pkgs.qt6.qtwebengine}/include/QtWebEngineWidgets"
      # Base include dirs — for qualified includes like <QtMultimedia/foo.h>
      "-I${pkgs.qt6.qtmultimedia}/include"
      "-I${pkgs.qt6.qtwebengine}/include"
      # GL headers
      "-I${pkgs.libglvnd.dev}/include"
    ];
  };
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

  # Enable systemd's cpu controller for the cgroup2 root at boot. Without this,
  # /sys/fs/cgroup/cgroup.subtree_control is missing `cpu` when ananicy-cpp
  # starts, so its cgroup check fails and it disables cgroup support entirely
  # ("Cgroups are not available on this platform"). Once any service later
  # enables cpu in subtree_control the daemon works again, which is why a
  # post-boot `systemctl restart` is fine. NixOS only sets
  # DefaultIOAccounting/DefaultIPAccounting by default; Memory/Tasks get
  # enabled elsewhere, but CPU does not.
  systemd.settings.Manager.DefaultCPUAccounting = true;

  # Enable the cpu controller on the root cgroup before the daemon execs.
  # systemd's DefaultCPUAccounting= true and per-unit CPUAccounting= true do
  # NOT eagerly add `cpu` to /sys/fs/cgroup/cgroup.subtree_control, and a
  # per-unit setting only grants the read-only accounting interface
  # (cpu.stat/cpu.pressure) — ananicy-cpp's startup probe reads
  # cgroup.controllers on a freshly-mkdir'd top-level cgroup, which is empty
  # until `cpu` is in the root's subtree_control. Writing `+cpu` is
  # idempotent.
  systemd.services.ananicy-cpp.serviceConfig.ExecStartPre =
    let
      pre = pkgs.writeShellScript "ananicy-cpp-cgroup-pre" "echo +cpu > /sys/fs/cgroup/cgroup.subtree_control";
    in
    [ "${pre}" ];

  # Clean up the cgroup dirs ananicy-cpp creates so the next start is silent
  # (otherwise it warns "cgroup cpu80 already exists, ignoring" on every
  # restart). rmdir --ignore-fail-on-non-empty is a no-op if a process is
  # still in the cgroup.
  systemd.services.ananicy-cpp.serviceConfig.ExecStopPost =
    let
      cleanup = pkgs.writeShellScript "ananicy-cpp-cgroup-cleanup" ''
        for d in /sys/fs/cgroup/cpu80 /sys/fs/cgroup/cpu85 /sys/fs/cgroup/cpu90; do
          [ -e "$d" ] && rmdir --ignore-fail-on-non-empty "$d" 2>/dev/null
        done
      '';
    in
    [ "${cleanup}" ];
  services = {
    thermald.enable = true;
    upower.enable = true;
    printing = {
      enable = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    kanata = {
      enable = true;
      keyboards.mykeyboard = {
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        config = ''
          (defsrc
            caps j k l ;
          )
          (defvar
            tap-time 150
            hold-time 200
          )

          (defalias
            escctrl (tap-hold 100 100 esc lctl)
            j (tap-hold $tap-time $hold-time j rctl)
            k (tap-hold $tap-time $hold-time k rsft)
            l (tap-hold $tap-time $hold-time l ralt)
            ; (tap-hold $tap-time $hold-time ; rmet)
          )

          (deflayer base
            @escctrl @j @k @l @;
          )
        '';
      };
    };
    snapper = {
      configs.home = {
        SUBVOLUME = "/home";

        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 12;
      };
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
    fwupd.enable = true;
    gnome.gnome-online-accounts.enable = true;
    gvfs.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
      # Upstream ananicy-cpp logs `add_pid_to_cgroup: cgroup error: couldn't add
      # task to cgroup /sys/fs/cgroup/cgroup.procs (Invalid argument)` for kernel
      # threads (migration/N, idle_inject/N) under cgroup v2. The kernel rejects
      # moving kthreads out of their current cgroup, and the upstream maintainer
      # marks it WONTFIX (gitlab work items #36, #66). Disable the workaround;
      # nixpkgs hard-codes it as `true` (not mkOptionDefault), so mkForce is
      # required. The nixpkgs module should be using mkOptionDefault; tracked
      # upstream as a separate concern.
      settings.cgroup_realtime_workaround = lib.mkForce false;
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 10;
      freeSwapThreshold = 50;
    };
    ntpd-rs.enable = true;
    fstrim.enable = true;
    dnscrypt-proxy = {
      enable = true;
      settings = {
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = false;
        http3 = true;
        server_names = [ "cloudflare-security" ];

        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];
      };
    };
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    libinput.enable = true;
    displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "hyprland";
        customConfig = ''
          env = XCURSOR_THEME,Windows
          env = XCURSOR_SIZE,25
          env = DMS_RUN_GREETER,1

          misc {
            disable_hyprland_logo = true
          }
        '';
      };
      configHome = "/home/muntasir";
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "muntasir"
    ];
    accept-flake-config = true;
  };

  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  # I use earlyoom.
  systemd.oomd.enable = false;

  # qt-build-utils's link_qt_library looks for .prl files in
  # QT_INSTALL_LIBS (qtbase's lib dir). Multimedia and WebEngine live in
  # separate Nix store paths, so those .prl files aren't found. Symlink them
  # into a merged tmpfs directory and point QMAKE at it.
  systemd.tmpfiles.settings."qt6-libs" =
    let
      link =
        pkg: ext: modules:
        builtins.foldl' lib.recursiveUpdate { } (
          map (m: {
            "/run/qt6-lib/libQt6${m}.${ext}" = {
              L.argument = "${pkg}/lib/libQt6${m}.${ext}";
            };
          }) modules
        );
      all = pkg: modules: lib.recursiveUpdate (link pkg "prl" modules) (link pkg "so" modules);
    in
    lib.recursiveUpdate
      (all pkgs.qt6.qtbase [
        "Core"
        "Gui"
        "Widgets"
        "OpenGLWidgets"
        "OpenGL"
        "Network"
      ])
      (
        lib.recursiveUpdate
          (all pkgs.qt6.qtmultimedia [
            "Multimedia"
            "MultimediaWidgets"
          ])
          (
            all pkgs.qt6.qtwebengine [
              "WebEngineCore"
              "WebEngineWidgets"
            ]
          )
      );

  environment.sessionVariables = {
    PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
    # qt-build-utils's cargo_link_libraries emits rustc-link-lib for all
    # Qt modules but only sets rustc-link-search for qtbase's lib dir.
    # Append extra lib dirs so the linker finds Multimedia/WebEngine libs.
    # rustc-link-search points to /run/qt6-lib (via QMAKE wrapper), which
    # only has .prl symlinks, not the actual .so files. Add all Qt lib dirs
    # explicitly so the linker finds the shared libraries.
    LIBRARY_PATH = "$NIX_LD_LIBRARY_PATH:${pkgs.qt6.qtbase}/lib:${pkgs.qt6.qtmultimedia}/lib:${pkgs.qt6.qtwebengine}/lib:${pkgs.qt6.qtdeclarative}/lib:${pkgs.qt6.qtwebchannel}/lib:${pkgs.qt6.qtpositioning}/lib";
    LD_LIBRARY_PATH = "$NIX_LD_LIBRARY_PATH";
    # qt-build-utils uses qmake -query QT_INSTALL_LIBS to locate .prl files.
    # Our tmpfiles rule puts symlinks at /run/qt6-lib; this wrapper returns
    # that path for the LIBS query and delegates everything else to real qmake.
    QMAKE = "${pkgs.writeShellScriptBin "qmake-wrapper" ''
      if [ "$1" = "-query" ] && [ "$2" = "QT_INSTALL_LIBS" ]; then
        echo "/run/qt6-lib"
      else
        exec "${pkgs.qt6.qtbase}/bin/qmake" "$@"
      fi
    ''}/bin/qmake-wrapper";
  };

  cachyos.settings = {
    enable = true;
    # I use ntpd-rs
    timesyncd.enable = false;
    # I use dnscrypt-proxy
    networkManager.enable = false;
    # Not needed on nixos?
    debuginfod.enable = false;
  };

  chaotic = {
    appmenu-gtk3-module.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
