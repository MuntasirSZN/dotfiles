{ pkgs, ... }:

{
  # No tray icon fix
  home.file.".config/systemd/user/app-org.keepassxc.KeePassXC@autostart.service.d/override.conf" = {
    text = ''
      [Service]
      ExecCondition=${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition "" "KDE:GNOME:COSMIC"
      ExecStartPre=${pkgs.coreutils-full}/bin/sleep 5
    '';
    force = true;
  };

  xdg.autostart.enable = true;
}
