module CheckAll (main) where

import CheckAll.ScriptFile (ScriptFile (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Data.Text qualified as Text
import System.Process.Typed (runProcess, shell)

main :: IO ()
main = do
  let script = ScriptFile.parse ""
  let (ScriptFile cmd) = script
  runProcess (shell $ Text.unpack cmd) >>= print
