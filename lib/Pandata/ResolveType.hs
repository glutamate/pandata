module Pandata.ResolveType where

import Data.Text (Text)
import qualified Data.Text as T
import Pandata.Types

typeOf :: V -> T
typeOf (VInt _) = TCon "Int"

generalise :: T -> T -> T
generalise (TCon "Int") (TCon "Double") = (TCon "Double")
generalise (Array t1) (Array t2) = Array $ generalise t1 t2
generalise (Sequence t1) (Sequence t2) = Sequence $ generalise t1 t2
generalise t1 t2
  | t1 == t2 = t1
  | otherwise = flatSum1 [t1, t2]

flatSum1 :: [T] -> T
flatSum1 = Sum . concatMap f where
  f (Sum ts) = ts
  f t = [t]