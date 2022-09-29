module CheckAllSpec where

import CheckAll qualified
import SpecPrelude
import System.Directory (doesFileExist, withCurrentDirectory)
import System.IO.Temp (withTempDirectory)

spec :: Spec
spec = do
  it "runs a single command" $ do
    withTestDir $ do
      run
        [ "- `cp a.in a.out`"
        ]
      exists <- doesFileExist "a.out"
      exists `shouldBe` True

  it "runs nested commands child-first" $ do
    withTestDir $ do
      run
        [ "- `cp a.out b.out`",
          "    - `cp a.in a.out`"
        ]
      exists <- doesFileExist "b.out"
      exists `shouldBe` True

  it "runs nested multiple top-level commands" $ do
    withTestDir $ do
      run
        [ "- `cp a.in a.out`",
          "- `cp a.in b.out`"
        ]
      existsA <- doesFileExist "a.out"
      existsB <- doesFileExist "b.out"
      (existsA, existsB) `shouldBe` (True, True)

  it "stops when a dependency command fails" $ do
    withTestDir $ do
      run
        [ "- `cp a.in a.out`",
          "    - `false`"
        ]
      exists <- doesFileExist "a.out"
      exists `shouldBe` False

run :: [String] -> IO ()
run scriptFileLines = do
  writeFile ".cafile" $ unlines scriptFileLines
  CheckAll.main

withTestDir :: IO () -> IO ()
withTestDir action =
  withTempDirectory "." "testdir" $ \tempdir -> do
    withCurrentDirectory tempdir $ do
      writeFile "a.in" ""
      action
