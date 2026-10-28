# All system services.
{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  services = {
    power-profiles-daemon.enable = true;
    usbguard = {
      enable = true;
      dbus.enable = true;
      restoreControllerDeviceState = true;
      IPCAllowedUsers = [
        "root"
        "muntasir"
      ];
    };
    geoclue2.enable = true;
    udev.packages = with pkgs; [
      steam-devices-udev-rules
    ];
    flatpak.enable = true;

    thermald.enable = true;
    upower.enable = true;

    printing = {
      enable = true;
      listenAddresses = [ "0.0.0.0:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      settings.publish = {
        disable-publishing = false;
        disable-user-service-publishing = false;
        publish-addresses = true;
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
      cleanupInterval = "1h";

      configs.home = {
        SUBVOLUME = "/home";

        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = 1;
        TIMELINE_LIMIT_DAILY = 1;
        TIMELINE_LIMIT_WEEKLY = 8;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;

        NUMBER_CLEANUP = true;
        NUMBER_LIMIT = 10;
      };
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    fwupd.enable = true;
    gnome = {
      gnome-online-accounts.enable = true;
      sushi.enable = true;
    };
    gvfs.enable = true;

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
      settings = {
        apply_latnice = true;
        check_freq = 15;
        loglevel = "info";
        log_applied_rule = false;
        cgroup_realtime_workaround = lib.mkForce false;
      };
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
        server_names = [
          "cloudflare-security"
        ];
        blocked_names.blocked_names_file = pkgs.writeText "blocklist.txt" "${builtins.readFile inputs.mybase_blocklist}";
        allowed_names.allowed_names_file = pkgs.writeText "allowed-names.txt" ''
          ip-api.com
          t.co
        '';

        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];
      };
    };

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

    displayManager.dux-greeter = {
      enable = true;
      compositor = {
        name = "hyprland";
        customConfig = ''
          hl.env("XCURSOR_THEME", "Windows")
          hl.env("XCURSOR_SIZE", 25)
          hl.env("DMS_RUN_GREETER", 1)

          hl.config({
            misc = {
              disable_hyprland_logo = true,
              disable_splash_rendering = true,
            },
          })
        '';
      };
      configHome = "/home/muntasir";
    };
  };
}
