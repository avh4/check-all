{ sources ? import ./sources.nix, compiler ? "ghc924" }:
let
  gitignore = import sources."gitignore.nix" { };
  config = {
    packageOverrides = pkgs: rec {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          project = pkgs.haskell.packages."${compiler}".override {
            overrides = haskellPackagesNew: haskellPackagesOld: rec {
              check-all = pkgs.haskell.lib.overrideCabal
                (haskellPackagesNew.callPackage ../check-all.nix { })
                (orig: { src = gitignore.gitignoreSource ../.; });
              check-all-build = haskellPackagesNew.callPackage ../Shakefile { };
            };
          };
        };
      };
    };
  };

  pkgs = import sources.nixpkgs { inherit config; };

in {
  pkgs = pkgs;
  haskellPackages = pkgs.haskell.packages.project;
}
