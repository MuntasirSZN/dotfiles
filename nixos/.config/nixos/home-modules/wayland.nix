{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    extraConfig = ''
      require("main")
    '';
  };
}
