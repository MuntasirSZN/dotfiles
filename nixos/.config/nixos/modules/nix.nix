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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        # Work around upstream nixpkgs regressions that the flake.lock update
        # pulled in. `pythonPackagesExtensions` is applied to every Python
        # package set, so `python3.pkgs`, `python3Packages` and
        # `python314Packages` all stay consistent with each other.
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (self: super: {
            # NixOS/nixpkgs#576624: `buildPythonPackage` now defaults to
            # `__structuredAttrs = true`, which means only the `env` attribute
            # set reaches the builder. The sphinx hook reads `sphinxBuilders`
            # and `sphinxRoot` from the environment, so it silently fell back
            # to the "html" builder and the "man" output of `reuse` was never
            # produced, failing the build with
            # "failed to produce output path for output 'man'".
            # Falling back to the legacy (non-structured) environment exposes
            # those attributes to the hook again.
            reuse = super.reuse.overridePythonAttrs (old: {
              __structuredAttrs = false;
            });
          })
        ];
      })
    ];
  };
}
