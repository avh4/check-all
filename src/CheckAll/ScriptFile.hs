{-# OPTIONS_GHC -Wno-orphans #-}

module CheckAll.ScriptFile (ScriptFile (..), ScriptPart (..), parse) where

import CMark (Node (..), NodeType (..), commonmarkToNode)
import Data.Functor.Foldable (Base, Corecursive (..), Recursive (..), fold)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Text (Text)

data ScriptFile = ScriptFile [ScriptPart]
  deriving (Eq, Show)

data ScriptPart
  = Command (NonEmpty Text) [ScriptPart]
  deriving (Eq, Show)

parse :: Text -> ScriptFile
parse source =
  let markdown = commonmarkToNode [] source
   in ScriptFile $ fold parseNode markdown

parseNode :: NodeF [ScriptPart] -> [ScriptPart]
parseNode = \case
  NodeF (CODE code) [] -> [Command (code :| []) []]
  NodeF (CODE _) _ -> error "INTERNAL ERROR: Unexpected CODE inline with child nodes"
  NodeF ITEM ([Command code deps]:rest) -> [ Command code (deps <> mconcat rest)]
  NodeF _ children -> mconcat children

--
-- recursion-schemes support for CMark
--

data NodeF a = NodeF NodeType [a]
  deriving (Functor, Show)

type instance Base Node = NodeF

instance Recursive Node where
  project (Node _ type_ children) = NodeF type_ children

instance Corecursive Node where
  embed (NodeF type_ children) = Node Nothing type_ children
