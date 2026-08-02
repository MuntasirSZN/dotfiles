{ pkgs, ... }:

{
  systemd.user = {
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
}
