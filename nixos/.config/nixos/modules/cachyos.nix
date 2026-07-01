# CachyOS settings module.
_:

{
  cachyos.settings = {
    enable = true;
    # I use ntpd-rs
    timesyncd.enable = false;
    # I use dnscrypt-proxy
    networkManager.enable = false;
    # Not needed on nixos?
    debuginfod.enable = false;
  };
}
