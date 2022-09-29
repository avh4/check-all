{ config ? import ./nix/config.nix { } }:
let
  pkgs = config.pkgs;
  haskellPackages = config.haskellPackages;
in haskellPackages.shellFor {
  packages = p: [ p.check-all ];
  buildInputs = with pkgs; [
    # Tools required to build
    cabal-install

    # Dev tools
    cabal2nix
    git
    hpack
    niv
    nixfmt
    # Must use the same ghc as the project
    haskellPackages.ghcid
    haskellPackages.haskell-language-server
  ];
}
