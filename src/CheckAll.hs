module CheckAll (main) where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Control.Monad.Except (ExceptT, runExceptT, throwError)
import Control.Monad.Trans (lift)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.ANSI (blue, bold, brightRed, brightWhite, red)
import Data.Text.IO qualified as Text
import System.Process.Typed (ExitCode (..), runProcess, shell)

main :: IO ()
main = do
  scriptSource <- Text.readFile ".cafile"
  let script = ScriptFile.parse scriptSource
  let (ScriptFile cmds) = script
  result <- runExceptT $ runGroup cmds
  case result of
    Right () -> return ()
    Left (failedCommand, exitCode) -> do
      Text.putStrLn ""
      Text.putStrLn $ red "=== COMMAND FAILED =============================="
      Text.putStrLn $ red "=== " <> (bold . brightWhite) failedCommand
      Text.putStrLn $ red "=== exit code: " <> (bold . brightRed . Text.pack . show) exitCode

runGroup :: [ScriptPart] -> ExceptT (Text, Int) IO ()
runGroup = mapM_ runPart

runPart :: ScriptPart -> ExceptT (Text, Int) IO ()
runPart = \case
  Command cmds deps -> do
    runGroup deps
    mapM_ runCommand cmds

runCommand :: Text -> ExceptT (Text, Int) IO ()
runCommand cmd = do
  lift $ Text.putStrLn ""
  lift $ Text.putStrLn $ blue "=== RUNNING COMMAND ============================="
  lift $ Text.putStrLn $ blue "=== " <> (bold . brightWhite) cmd
  lift $ Text.putStrLn ""
  exitCode <- runProcess (shell $ Text.unpack cmd)
  case exitCode of
    ExitSuccess -> return ()
    ExitFailure code -> throwError (cmd, code)
