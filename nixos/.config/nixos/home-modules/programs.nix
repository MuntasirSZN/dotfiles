{ inputs, pkgs, ... }:

{
  programs = {
    keepassxc = {
      autostart = true;
      enable = true;
    };
    home-manager.enable = true;
    zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      profiles.default.sine.enable = true;
    };

    spicetify = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}; {
      enable = true;
      enabledExtensions = with extensions; [
        adblockify
      ];
      enabledCustomApps = with apps; [
        marketplace
        ncsVisualizer
      ];
      theme = themes.catppuccin;
      colorScheme = "mocha";
      wayland = true;
    };
  };
}
