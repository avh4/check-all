{ mkDerivation, base, cmark, directory, hspec, hspec-discover, lib
, recursion-schemes, temporary, text, typed-process }:
mkDerivation {
  pname = "check-all";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends =
    [ base cmark directory recursion-schemes text typed-process ];
  testHaskellDepends = [
    base
    cmark
    directory
    hspec
    recursion-schemes
    temporary
    text
    typed-process
  ];
  testToolDepends = [ hspec-discover ];
  description = "TODO";
  license = lib.licenses.gpl3Only;
  mainProgram = "check-all";
}
