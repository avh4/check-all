module CheckAll (main) where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (listToMaybe)
import Data.Text qualified as Text
import Data.Text.IO qualified as Text
import System.Process.Typed (runProcess, shell)

main :: IO ()
main = do
  scriptSource <- Text.readFile "check-all.ca"
  let script = ScriptFile.parse scriptSource
  let (ScriptFile cmds) = script
  case listToMaybe cmds of
    Just (Command (cmd :| []) _) ->
      runProcess (shell $ Text.unpack cmd) >>= print
    _ ->
      error "No commands found"
