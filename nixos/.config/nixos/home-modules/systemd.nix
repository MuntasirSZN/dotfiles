{
  config,
  lib,
  pkgs,
  ...
}:

{
  xdg.configFile."systemd/user/dms.service.d/override.conf".text =
    let
      home = config.home.homeDirectory;
      user = config.home.username;
    in
    ''
      [Service]
      Environment="PATH=${
        lib.makeSearchPathOutput "bin" "bin" [
          "${home}/.local"
          "/run/wrappers"
          "${home}/.local/share/flatpak/exports"
          "/var/lib/flatpak/exports"
          "${home}/.nix-profile"
          "${home}/.local/state/nix/profile"
          "/etc/profiles/per-user/${user}"
          "/nix/var/nix/profiles/default"
          "/run/current-system/sw"
        ]
      }"
    '';

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
          ExecStart = ''
            ${pkgs.rclone}/bin/rclone mount 'Google Muntasir:' %h/google \
              --cache-dir=%h/.cache/rclone-google \
              --vfs-cache-mode=full \
              --vfs-cache-max-size=10G \
              --vfs-cache-max-age=168h \
              --vfs-cache-poll-interval=1m \
              --vfs-write-back=1s \
              --buffer-size=16M \
              --dir-cache-time=1h \
              --attr-timeout=10s \
              --write-back-cache
          '';
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
    };
  };
}
