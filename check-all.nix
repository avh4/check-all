{ mkDerivation, base, cmark, directory, hspec, hspec-discover, lib, mtl
, recursion-schemes, temporary, text, text-ansi, typed-process }:
mkDerivation {
  pname = "check-all";
  version = "0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends =
    [ base cmark directory mtl recursion-schemes text text-ansi typed-process ];
  testHaskellDepends = [
    base
    cmark
    directory
    hspec
    mtl
    recursion-schemes
    temporary
    text
    text-ansi
    typed-process
  ];
  testToolDepends = [ hspec-discover ];
  description = "TODO";
  license = lib.licenses.gpl3Only;
  mainProgram = "check-all";
}
