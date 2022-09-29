module CheckAll (main) where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Text qualified as Text
import Data.Text.IO qualified as Text
import System.Process.Typed (runProcess, shell)

main :: IO ()
main = do
  scriptSource <- Text.readFile "check-all.ca"
  let script = ScriptFile.parse scriptSource
  let (ScriptFile cmds) = script
  runGroup cmds

runGroup :: [ScriptPart] -> IO ()
runGroup = mapM_ runPart

runPart :: ScriptPart -> IO ()
runPart = \case
  Command (cmd1 :| cmds) deps -> do
    runGroup deps
    runProcess (shell $ Text.unpack cmd1) >>= print
