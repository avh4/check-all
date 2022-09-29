module CheckAll.ScriptFileSpec where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Data.Text qualified as Text
import SpecPrelude

spec :: Spec
spec =
  describe "parsing" $ do
    it "parses a single command" $
      ScriptFile.parse "- `echo`"
        `shouldBe` ScriptFile [Command ["echo"] []]
    it "parses nested commands" $
      parse
        [ "- `a`",
          "  - `b`"
        ]
        `shouldBe` ScriptFile
          [ Command
              ["a"]
              [ Command ["b"] []
              ]
          ]
    it "parses nested commands with 4-space indent" $
      parse
        [ "- `a`",
          "    - `b`"
        ]
        `shouldBe` ScriptFile
          [ Command
              ["a"]
              [ Command ["b"] []
              ]
          ]

parse :: [Text.Text] -> ScriptFile
parse = ScriptFile.parse . Text.unlines
