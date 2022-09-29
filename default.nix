let config = import ./nix/config.nix { };
in { check-all = config.haskellPackages.check-all; }
