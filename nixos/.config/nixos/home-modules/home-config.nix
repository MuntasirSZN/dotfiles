{ pkgs, ... }:

{
  systemd.user.packages = [ pkgs.ghostty ];
  home.file = {
    # No tray icon fix
    ".config/systemd/user/app-org.keepassxc.KeePassXC@autostart.service.d/override.conf" = {
      text = ''
        [Service]
        ExecCondition=${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition "" "KDE:GNOME:COSMIC"
        ExecStartPre=${pkgs.coreutils-full}/bin/sleep 5
      '';
      force = true;
    };

    # Start XDG-autostart apps and the calendar after the shell is up.
    ".config/systemd/user/app-@autostart.service.d/override.conf" = {
      text = ''
        [Unit]
        After=dms.service
      '';
      force = true;
    };
    ".config/systemd/user/dcal.service.d/override.conf" = {
      text = ''
        [Unit]
        After=dms.service
      '';
      force = true;
    };
  };
  xdg.autostart.enable = true;
}
