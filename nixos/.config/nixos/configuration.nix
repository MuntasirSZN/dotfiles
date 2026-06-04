{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  findutils-name =
    "finduutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.findutils.version)
    );

  diffutils-name =
    "diffuutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.diffutils.version)
    );
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.cachyos-settings.nixosModules.default
  ];
  boot = {
    kernelPackages =
      let
        cachyos = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system};
        myKernel = cachyos.linux-cachyos-bore-lto-x86_64-v3.override {
          bbr3 = true;
          performanceGovernor = true;
          kcfi = true;
          autofdo = true;
          acpiCall = true;
        };
      in
      cachyos.linuxPackages-cachyos-bore-lto-x86_64-v3.override {
        kernel = myKernel;
      };
    loader = {
      limine = {
        enable = true;
        efiSupport = true;
        secureBoot.enable = true;
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
  };

  users.users.muntasir = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };
  environment.systemPackages = with pkgs; [
    jdk21
    glfw
    openal
    alsa-lib
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
    cups
    dbus
    expat
    gtk3
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
  ];

  programs = {
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
      libraries = with pkgs; [
        libx11
        libxcursor
        libxrandr
        libxi
        libxext
        libxrender
        libxfixes
        libxinerama
        libxxf86vm
        libGL
        jdk21
        glfw
        openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire
        udev
        vulkan-loader
        glib
        gtk3
        zlib
        openssl
        libxtst
        freetype
        nspr
        nss
        atk
        at-spi2-atk
        cups
        dbus
        expat
        libdrm
        libgbm
        libxkbcommon
        mesa
        pango
        libxcomposite
        libxdamage
        libxcb
        cairo
        gdk-pixbuf
      ];
    };
  };
  environment.variables = {
    CC = "clang";
    CXX = "clang++";
  };
  hardware = {
    graphics.enable = true;
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
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
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
    };
    libinput.enable = true;
    displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "hyprland";
        customConfig = ''
          env = HYPRCURSOR_THEME,Windows
          env = XCURSOR_THEME,Windows
          env = HYPRCURSOR_SIZE,24
          env = XCURSOR_SIZE,24
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

  system.replaceDependencies.replacements = [
    # add uutils when mv is fixed
    # findutils
    {
      # applications
      oldDependency = pkgs.findutils;
      newDependency = pkgs.symlinkJoin {
        # Make the name length match so it builds
        name = findutils-name;
        paths = [ pkgs.uutils-findutils ];
      };
    }
    # diffutils
    {
      # applications
      oldDependency = pkgs.diffutils;
      newDependency = pkgs.symlinkJoin {
        # Make the name length match so it builds
        name = diffutils-name;
        paths = [ pkgs.uutils-diffutils ];
      };
    }
  ];

  # I hate this. Kills entire cgroups.
  systemd.oomd.enable = false;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
  ];

  cachyos.settings = {
    enable = true;
    timesyncd.enable = false;
    networkManager.enable = false;
    debuginfod.enable = false;
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
