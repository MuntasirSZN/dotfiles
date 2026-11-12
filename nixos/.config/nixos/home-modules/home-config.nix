{ pkgs, ... }:

{
  # Units from app packages, linked into ~/.local/share/systemd/user (a stable
  # path that survives package upgrades, unlike systemctl --user link).
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

    # Dux Files service fixes.
    #
    # 1. The dux-files package ships its own lib/systemd/user/dfiles.service and
    #    the NixOS programs.dux-files module generates the same unit, which NixOS
    #    installs as /etc/systemd/user/dfiles.service.d/overrides.conf (drop-in,
    #    since the package unit already exists). The merged unit then gets two
    #    ExecStart= lines and systemd refuses to start it:
    #    "Service has more than one ExecStart= setting ... Refusing."
    #    Clearing ExecStart= here resets the list so exactly one remains.
    #
    # 2. The NixOS default PATH for user services (coreutils, findutils, grep,
    #    sed, systemd) cannot resolve desktop-entry Exec=/TryExec names, and
    #    dfiles looks handlers up via PATH — so opening any file from Files said
    #    "This item could not be handled" while `dfiles` in a shell worked.
    #    Give the service the login-shell PATH instead.
    ".config/systemd/user/dfiles.service.d/zzz-fix.conf" = {
      text = ''
        [Service]
        ExecStart=
        ExecStart=/run/current-system/sw/bin/dfiles run --session --hidden --keep-running
        Environment="PATH=/home/muntasir/.local/bin:/home/muntasir/.cargo/bin:/run/wrappers/bin:/home/muntasir/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:/home/muntasir/.nix-profile/bin:/nix/profile/bin:/home/muntasir/.local/state/nix/profile/bin:/etc/profiles/per-user/muntasir/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      '';
      force = true;
    };
  };

  xdg.autostart.enable = true;
}
