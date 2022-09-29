module CheckAll.ScriptFileSpec where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import SpecPrelude

spec :: Spec
spec =
  describe "parsing" $ do
    it "parses a single command" $
      ScriptFile.parse "- `echo`"
        `shouldBe` ScriptFile [Command ["echo"] []]
