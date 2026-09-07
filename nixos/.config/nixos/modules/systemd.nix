# Systemd tweaks, oomd, tmpfiles, ananicy-cpp cgroup hooks.
{
  pkgs,
  ...
}:

{
  systemd = {
    services = {
      # It's not a company PC or something. Also, I get this weird error
      # no more space left on device, so its useless anyway. (Tried clearing the tpm)
      "systemd-pcrlogin@".enable = false;
      ananicy-cpp = {
        # Fix weird startup error "Cgroup not supported + no cpu controller"
        serviceConfig.Delegate = "yes";
        # Clean up the cgroup dirs ananicy-cpp creates so the next start is silent
        # (otherwise it warns "cgroup cpu80 already exists, ignoring" on every
        # restart). rmdir --ignore-fail-on-non-empty is a no-op if a process is
        # still in the cgroup.
        serviceConfig.ExecStopPost =
          let
            cleanup = pkgs.writeShellScript "ananicy-cpp-cgroup-cleanup" ''
              for d in /sys/fs/cgroup/cpu80 /sys/fs/cgroup/cpu85 /sys/fs/cgroup/cpu90; do
                [ -e "$d" ] && rmdir --ignore-fail-on-non-empty "$d" 2>/dev/null
              done
            '';
          in
          [ "${cleanup}" ];
      };
    };

    # I use earlyoom.
    oomd.enable = false;
  };
}
