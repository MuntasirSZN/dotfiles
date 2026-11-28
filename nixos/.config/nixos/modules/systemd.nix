# Systemd tweaks, oomd, tmpfiles, ananicy-cpp cgroup hooks.
{
  pkgs,
  ...
}:

{
  systemd = {
    services = {
      thermald.serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
      };
      dnscrypt-proxy.serviceConfig.StateDirectory = "dnscrypt-proxy";
      # It's not a company PC or something. Also, I get this weird error
      # no more space left on device, so its useless anyway. (Tried clearing the tpm)
      "systemd-pcrlogin@".enable = false;
    };

    # x86sim needs /opt.
    tmpfiles.rules = [ "d /opt 0755 root root -" ];

    # I use earlyoom.
    oomd.enable = false;
  };
}
