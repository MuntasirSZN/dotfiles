# Systemd tweaks, oomd, tmpfiles, ananicy-cpp cgroup hooks.
{
  lib,
  pkgs,
  ...
}:

{
  systemd = {
    services = {
      # Enable the cpu controller on the root cgroup before the daemon execs.
      # systemd's DefaultCPUAccounting= true and per-unit CPUAccounting= true do
      # NOT eagerly add `cpu` to /sys/fs/cgroup/cgroup.subtree_control, and a
      # per-unit setting only grants the read-only accounting interface
      # (cpu.stat/cpu.pressure) — ananicy-cpp's startup probe reads
      # cgroup.controllers on a freshly-mkdir'd top-level cgroup, which is empty
      # until `cpu` is in the root's subtree_control. Writing `+cpu` is
      # idempotent.
      ananicy-cpp.serviceConfig.ExecStartPre =
        let
          pre = pkgs.writeShellScript "ananicy-cpp-cgroup-pre" "echo +cpu > /sys/fs/cgroup/cgroup.subtree_control";
        in
        [ "${pre}" ];

      # Clean up the cgroup dirs ananicy-cpp creates so the next start is silent
      # (otherwise it warns "cgroup cpu80 already exists, ignoring" on every
      # restart). rmdir --ignore-fail-on-non-empty is a no-op if a process is
      # still in the cgroup.
      ananicy-cpp.serviceConfig.ExecStopPost =
        let
          cleanup = pkgs.writeShellScript "ananicy-cpp-cgroup-cleanup" ''
            for d in /sys/fs/cgroup/cpu80 /sys/fs/cgroup/cpu85 /sys/fs/cgroup/cpu90; do
              [ -e "$d" ] && rmdir --ignore-fail-on-non-empty "$d" 2>/dev/null
            done
          '';
        in
        [ "${cleanup}" ];
    };
    # Enable systemd's cpu controller for the cgroup2 root at boot. Without this,
    # /sys/fs/cgroup/cgroup.subtree_control is missing `cpu` when ananicy-cpp
    # starts, so its cgroup check fails and it disables cgroup support entirely
    # ("Cgroups are not available on this platform"). Once any service later
    # enables cpu in subtree_control the daemon works again, which is why a
    # post-boot `systemctl restart` is fine. NixOS only sets
    # DefaultIOAccounting/DefaultIPAccounting by default; Memory/Tasks get
    # enabled elsewhere, but CPU does not.
    settings.Manager.DefaultCPUAccounting = true;

    # I use earlyoom.
    oomd.enable = false;

    # qt-build-utils's link_qt_library looks for .prl files in
    # QT_INSTALL_LIBS (qtbase's lib dir). Multimedia and WebEngine live in
    # separate Nix store paths, so those .prl files aren't found. Symlink them
    # into a merged tmpfs directory and point QMAKE at it.
    tmpfiles.settings."qt6-libs" =
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
  };
}
