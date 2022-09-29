module MainSpec where

import CheckAll qualified
import SpecPrelude
import System.Directory (doesFileExist, withCurrentDirectory)
import System.IO.Temp (withTempDirectory)

spec :: Spec
spec =
  it "runs a single command" $ do
    withTestDir $ do
      run
        [ "- cp a.in a.out"
        ]
      exists <- doesFileExist "a.out"
      exists `shouldBe` True

run :: [String] -> IO ()
run _ = do
  CheckAll.main

withTestDir :: IO () -> IO ()
withTestDir action =
  withTempDirectory "." "testdir" $ \tempdir -> do
    withCurrentDirectory tempdir $ do
      writeFile "a.in" ""
      action
