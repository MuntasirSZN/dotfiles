{
  description = "Muntasir's Nix configuration for Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    homeConfigurations = {
      hyprpc = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home.username = "muntasir";
            home.homeDirectory = "/home/muntasir";
            home.stateVersion = "24.05"; 

            nix.package = pkgs.nix;

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            home.packages = with pkgs; [
              vim
            ];
            # Additional configuration options can go here
          }
        ];
      };
    };
  };
}

