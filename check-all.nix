{ mkDerivation, base, directory, hspec, hspec-discover, lib, temporary
, typed-process }:
mkDerivation {
  pname = "check-all";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base directory typed-process ];
  testHaskellDepends = [ base directory hspec temporary typed-process ];
  testToolDepends = [ hspec-discover ];
  description = "TODO";
  license = lib.licenses.gpl3Only;
  mainProgram = "check-all";
}
