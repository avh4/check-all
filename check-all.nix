{ mkDerivation, base, hspec, hspec-discover, lib }:
mkDerivation {
  pname = "check-all";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base hspec ];
  testToolDepends = [ hspec-discover ];
  description = "TODO";
  license = lib.licenses.gpl3Only;
  mainProgram = "check-all";
}
