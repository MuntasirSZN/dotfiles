# Security-related options.
{
  lib,
  pkgs,
  config,
  ...
}:

{
  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
    pam.services = {
      su.requireWheel = true;
      su-l.requireWheel = true;
      passwd.rules.password = {
        unix = {
          control = lib.mkForce "required";
          settings.use_authtok = true;
        };
        pwquality = {
          control = "required";
          modulePath = "${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so";
          # order BEFORE pam_unix.so
          order = config.security.pam.services.passwd.rules.password.unix.order - 10;
          settings = {
            retry = 3;
            minlen = 8;
            difok = 6;
            dcredit = -1;
            ucredit = 1;
            ocredit = -1;
            lcredit = 1;
            enforce_for_root = true;
          };
        };
      };
    };
  };
}
