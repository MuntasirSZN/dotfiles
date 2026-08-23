# XDG Desktop Portal configuration.
{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-luminous
      oo7-portal
    ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "luminous"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "oo7-portal"
        ];
        "org.freedesktop.impl.portal.Settings" = [
          "luminous"
          "gtk"
        ];
      };
    };
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
