# Programs configuration (Hyprland, dms-shell, ZSH, GPG, nix-ld, etc.).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  dmsPkg = pkgs.dms-shell;
  systemQtMm = pkgs.qt6.qtmultimedia; # 6.11.1 — works

  # Patch dms wrapper: replace kde's qtmultimedia (6.11.0) paths with
  # system qt6.qtmultimedia (6.11.1).  The 6.11.0 multimedia plugins
  # fail with ResourceError "Not available" against the 6.11.1 runtime.
  fixedDms = pkgs.runCommand "dms-shell-fixed" { meta.mainProgram = "dms"; } ''
    mkdir -p $out/bin $out/share/systemd/user $out/lib/systemd/user

    # Copy binary assets
    cp ${dmsPkg}/bin/.dms-wrapped $out/bin/.dms-wrapped

    # Patch wrapper's qtmultimedia paths
    substitute ${dmsPkg}/bin/dms $out/bin/dms \
      --replace-fail "${pkgs.kdePackages.qtmultimedia}" "${systemQtMm}"
    chmod +x $out/bin/dms

    # Patch service files in both locations (fix ExecStart store path)
    substitute ${dmsPkg}/lib/systemd/user/dms.service $out/lib/systemd/user/dms.service \
      --replace-fail "${dmsPkg}" "$out"
    substitute ${dmsPkg}/share/systemd/user/dms.service $out/share/systemd/user/dms.service \
      --replace-fail "${dmsPkg}" "$out"

    # Copy remaining share content (QML, icons, etc.)
    for d in ${dmsPkg}/share/*; do
      base=$(basename "$d")
      [ "$base" = "systemd" ] && continue  # already handled above
      cp -rL "$d" "$out/share/$base"
    done
  '';
in

{
  # Use our patched package (mkForce — highest priority).
  programs.dms-shell.package = lib.mkForce fixedDms;

  systemd.user.services.dms.serviceConfig.Environment = [
    "QML2_IMPORT_PATH=${systemQtMm}/lib/qt-6/qml"
  ];

  programs = {
    gamemode.enable = true;
    kdeconnect.enable = true;

    hyprland = {
      enable = true;
      withUWSM = false;
    };

    dms-shell = {
      enable = true;
      quickshell.package = pkgs.quickshell;
      enableSystemMonitoring = true;
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
    fish.enable = true;
    bash.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld = {
      enable = true;
      libraries = config.custom.packages.system;
    };
  };
}
