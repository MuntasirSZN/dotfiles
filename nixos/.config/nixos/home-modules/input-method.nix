{ pkgs, ... }:

{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      catppuccin-fcitx5
      fcitx5-m17n
      fcitx5-openbangla-keyboard
      qt6Packages.fcitx5-configtool
    ];
  };
}
