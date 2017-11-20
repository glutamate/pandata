module Pandata.Syntax where

import Data.Text (Text)
import qualified Data.Text as T
import Pandata.Types
import Data.Monoid ((<>))
import Data.Foldable
import qualified Data.Map.Strict as Map

ppType :: T -> Text
ppType (TCon t) = t
ppType (Enum ts) = "Enum{"<>T.intercalate "," (toList ts) <>"}"
ppType (Array t) = "Array<"<>ppType t<>">"
ppType (Sequence t) = "Seq<"<>ppType t<>">"
ppType (Sum ts) = T.intercalate "|" $ map ppType $ toList ts
ppType (Prod ts) = "("<>T.intercalate "," (map ppType $ toList ts) <>")"
ppType (Nullable t) = ppType t <> "?"
ppType (Rec ts) = "{"<>T.intercalate "," (map f $ Map.toList ts) <>"}"
  where f (k,v) = k <> ": "<> ppType v

