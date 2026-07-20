{
  pkgs,
  inputs,
  devClosure,
  ...
}:

{
  home = {
    username = "muntasir";
    homeDirectory = "/home/muntasir";

    stateVersion = "26.05";
    enableNixpkgsReleaseCheck = false;

    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.callPackage ./pkgs/windows-cursor-theme { };
      name = "Windows";
      size = 25;
    };

    packages =
      let
        topLevel = with pkgs; [
          satty
          slurp
          gpu-screen-recorder
          azure-cli
          aflplusplus
          # Kani CBMC solvers
          cadical
          minisat
          kissat
          z3
          bitwuzla
          cvc5
          perf
          libllvm
          yt-dlp
          entr
          rustdesk
          sqlite
          texliveBasic
          biber
          tectonic
          statix
          ghostscript
          libnotify
          ghostty
          imagemagick
          fzf
          vivid
          clang
          nwg-look
          cava
          pavucontrol
          cmake
          gnumake
          git-credential-keepassxc
          vicinae
          matugen
          khal
          vdirsyncer
          wtype
          dgop
          libsForQt5.qt5ct
          qt6Packages.qt6ct
          nautilus
          nautilus-open-any-terminal
          evince
          loupe
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
          eask-cli
          doppler
          gvfs
          simple-mtpfs
          libmtp
          gnome-online-accounts-gtk
          keepassxc
          rclone-browser
          rclone
          nixfmt
        ];
      in
      topLevel ++ devClosure topLevel;

    # Otherwise, xdg-desktop-portal-gtk doesn't work
    file.".config/systemd/user/xdg-desktop-portal.service.d/env-override.conf".text = ''
      [Service]
      UnsetEnvironment=NIX_XDG_DESKTOP_PORTAL_DIR
    '';
    # No tray icon fix
    file.".config/systemd/user/app-org.keepassxc.KeePassXC@autostart.service.d/override.conf" = {
      text = ''
        [Service]
        ExecCondition=${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition "" "KDE:GNOME:COSMIC"
        ExecStartPre=${pkgs.coreutils-full}/bin/sleep 5
      '';
      force = true;
    };
  };
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nix-index-database.homeModules.default
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    extraConfig = ''
      require("main")
    '';
  };

  programs = {
    keepassxc = {
      autostart = true;
      enable = true;
    };
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
        fullScreen
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
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      catppuccin-fcitx5
      fcitx5-m17n
      fcitx5-openbangla-keyboard
      qt6Packages.fcitx5-configtool
    ];
  };
  systemd = {
    user = {
      services = {
        rclone-google = {
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
        openbangla = {
          Unit = {
            Description = "Run OpenBangla";
            After = [ "dms.service" ];
            PartOf = [ "dms.service" ];
          };

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.openbangla-keyboard}/bin/openbangla-gui --tray";
            ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 8";
            ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition '' 'KDE:GNOME:COSMIC'";
            Restart = "on-failure";
            RestartSec = "10s";
          };

          Install = {
            WantedBy = [ "dms.service" ];
          };
        };
        vdirsyncer-sync = {
          Unit = {
            Description = "Run vdirsyncer sync";
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
          };
        };
      };
      timers.vdirsyncer-sync = {
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
    };
  };
}
