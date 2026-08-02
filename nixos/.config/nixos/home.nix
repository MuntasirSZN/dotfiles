{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./home-modules/packages.nix
    ./home-modules/programs.nix
    ./home-modules/wayland.nix
    ./home-modules/systemd.nix
    ./home-modules/input-method.nix
    ./home-modules/home-config.nix
    inputs.zen-browser.homeModules.beta
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nix-index-database.homeModules.default
  ];

  home = {
    username = "muntasir";
    homeDirectory = "/home/muntasir";

    stateVersion = "26.05";
    enableNixpkgsReleaseCheck = false;

    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.callPackage ./pkgs/windows-cursor-theme { };
      name = "Windows";
      size = 25;
    };
  };
}
