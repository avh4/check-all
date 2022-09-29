module CheckAll.ScriptFile (ScriptFile(..), parse) where
import Data.Text (Text)

data ScriptFile = ScriptFile Text

parse :: Text -> ScriptFile
parse source =
  ScriptFile "cp a.in a.out"
