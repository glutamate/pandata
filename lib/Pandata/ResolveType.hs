module Pandata.ResolveType where

import Data.Text (Text)
import qualified Data.Text as T
import Pandata.Types

typeOf :: V -> T
typeOf (VInt _) = TCon "Int"

generalise :: T -> T -> T
generalise (TCon "Int") (TCon "Double") = (TCon "Double")
generalise t1 t2 = flatSum $ Sum [t1, t2]

flatSum :: T -> T
flatSum t = t