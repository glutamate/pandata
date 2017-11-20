module Pandata.Syntax where

import Data.Text (Text)
import qualified Data.Text as T
import Pandata.Types
import Data.Monoid

ppType :: T -> Text
ppType (TCon t) = t
ppType (Enum ts) = "Enum{"<>T.intercalate "," ts<>"}"
ppType (Array t) = "Array<"<>ppType t<>">"
