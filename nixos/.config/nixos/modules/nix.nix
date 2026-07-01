# Nix daemon settings and nixpkgs configuration.
_:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "muntasir"
    ];
    accept-flake-config = true;
  };

  nixpkgs.config.allowUnfree = true;
}
