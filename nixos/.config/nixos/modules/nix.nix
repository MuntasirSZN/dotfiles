# Nix daemon settings and nixpkgs configuration.
_:

{
  nix = {
    optimise.automatic = true;
    settings = {
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
  };

  nixpkgs.config = {
    allowUnfree = true;
    # gtk2 is still pulled in by lutris's FHS environment; nixpkgs marks it
    # broken and plans to remove it in NixOS 27.05.
    problems.handlers."gtk+".broken = "warn";
  };
}
