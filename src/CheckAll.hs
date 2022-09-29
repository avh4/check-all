module CheckAll (main) where

import CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..))
import CheckAll.ScriptFile qualified as ScriptFile
import Control.Exception (try)
import Control.Monad.Except (ExceptT, runExceptT, throwError)
import Control.Monad.Trans (lift)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.ANSI (blue, bold, brightRed, brightWhite, red)
import Data.Text.IO qualified as Text
import System.Process.Typed (ExitCode (..), runProcess, shell)

main :: IO ()
main = do
  scriptSource <- try @IOError $ Text.readFile ".cafile"
  either (\_ -> showInitHelp) runScript scriptSource

showInitHelp :: IO ()
showInitHelp = do
  Text.putStrLn "ca - check all"
  Text.putStrLn ""
  Text.putStrLn $ "No " <> bold ".cafile" <> " was found."
  Text.putStrLn ""
  Text.putStrLn "Create a .cafile in the current directory with the following format"
  Text.putStrLn "(it's markdown with lists containing code spans):"
  Text.putStrLn ""
  Text.putStrLn "- `npm test`"
  Text.putStrLn "    - `elm-test`"
  Text.putStrLn "        - `elm-test test/LandingPageTest.elm`"
  Text.putStrLn "        - `elm-test test/LoginPageTest.elm`"
  Text.putStrLn "    - `elm test`"
  Text.putStrLn "    - `elm-format`"
  Text.putStrLn ""
  Text.putStrLn "The outline will be traversed depth-first, and the parent commands will"
  Text.putStrLn "only be run if all its children succeed."

runScript :: Text -> IO ()
runScript scriptSource = do
  let script = ScriptFile.parse scriptSource
  let (ScriptFile cmds) = script
  result <- runExceptT $ runGroup cmds
  case result of
    Right () -> return ()
    Left (failedCommand, exitCode) -> do
      Text.putStrLn ""
      Text.putStrLn $ red "^^^ COMMAND FAILED ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
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
