module SpecPrelude
  ( shouldHave
  , module Test.Hspec
  ) where

import Test.Hspec


shouldHave :: (Eq b, Show b) => a -> (a -> b) -> b -> Expectation
shouldHave a f expected =
  f a `shouldBe` expected
