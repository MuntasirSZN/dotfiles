{ lib }:

let
  inherit (lib) isDerivation filter unique concatMap;

  # A package has a "real" `dev` output when the `dev` output is a different
  # store path from `out`. Most applications have `dev = out`; libraries that
  # split outputs (gtk4, glib, cairo, pipewire, ...) have a distinct one.
  hasRealDev =
    p:
    isDerivation p
    && p ? dev
    && p.dev.outPath != p.outPath;

  # Direct build / propagated inputs of a single derivation. We deliberately
  # don't walk transitive deps: NixOS / Home Manager already materialise
  # those through the system / user profile closure, and a full recursive
  # walk blows up evaluation time.
  directInputs =
    p:
    (p.buildInputs or [ ])
    ++ (p.nativeBuildInputs or [ ])
    ++ (p.propagatedBuildInputs or [ ])
    ++ (p.propagatedNativeBuildInputs or [ ]);

  # The set we look at: top-level packages + their direct inputs.
  candidates = topLevel: unique (filter isDerivation (
    topLevel
    ++ concatMap directInputs (filter isDerivation topLevel)
  ));

in
{
  /**
    Given a list of top-level packages, return the `.dev` output of every
    package in that list *and* in their direct `buildInputs` /
    `nativeBuildInputs` / `propagatedBuildInputs` /
    `propagatedNativeBuildInputs`. Items that don't expose a real `dev`
    output are silently dropped.

    Intended to be unioned with `environment.systemPackages` and
    `home.packages` so that headers, pkg-config files, and similar dev
    artifacts are available on PATH for whatever the user builds locally.

    # Inputs

    `topLevel`
    : A list of derivations (typically the result of `with pkgs; [ ... ]`).

    # Type

    ```
    devClosure :: [Derivation] -> [Derivation]
    ```

    # Examples

    :::{.example}
    ## `lib.devClosure` usage example

    ```nix
    devClosure (with pkgs; [ gtk4 pipewire ])
    => [ <gtk4-dev> <pipewire-dev> ... ]
    ```
    :::
  */
  devClosure = topLevel: map (p: p.dev) (filter hasRealDev (candidates topLevel));
}
