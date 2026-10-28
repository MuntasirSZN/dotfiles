# Nix daemon settings and nixpkgs configuration.
{ pkgs, lib, ... }:

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
        nautilus = prev.nautilus.overrideAttrs (nprev: {
          buildInputs =
            nprev.buildInputs
            ++ (with pkgs.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
            ]);
        });
      })
      # fabric 3.2.3 (pulled in by azure-cli) requires invoke < 3, but
      # nixpkgs ships invoke 3.x. Pin invoke 2.2.0 for fabric only.
      # azure-cli re-overrides python3 internally, so wrap its `override`
      # to keep this package override.
      # https://github.com/fabric/fabric/issues/2376
      (final: prev: {
        azure-cli = prev.azure-cli.override {
          python3 =
            let
              base = prev.python3;
              invokeOverride = self: super: {
                invoke = self.buildPythonPackage {
                  pname = "invoke";
                  version = "2.2.0";
                  format = "setuptools";
                  src = prev.fetchPypi {
                    pname = "invoke";
                    version = "2.2.0";
                    hash = "sha256-7my7EBrxqFnH/oTyomTAWQILDLf+NTX5QkMAq1aPa9U=";
                  };
                  postPatch = ''
                    sed -e 's|/bin/bash|${prev.bash}/bin/bash|g' -i invoke/config.py
                  '';
                  build-system = [ self.setuptools ];
                  doCheck = false;
                  pythonImportsCheck = [ "invoke" ];
                };
                fabric = super.fabric.override {
                  invoke = self.invoke;
                };
              };
            in
            base
            // {
              override =
                args:
                base.override (
                  args
                  // {
                    packageOverrides = lib.composeExtensions invokeOverride (args.packageOverrides or (_: _: { }));
                  }
                );
            };
        };
      })
    ];
  };
}
