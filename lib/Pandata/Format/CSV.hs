module Pandata.Format.CSV (csvFmt) where

import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Map.Strict as Map
import Pandata.Types
import Data.Csv
import qualified Data.Set as Set

csvFmt :: DataFormat FilePath
csvFmt = DataFormat
  { isTypeWritable = checkType

  }

checkType :: T -> Bool
checkType (Array t) = okRowT t
checkType (Sequence t) = okRowT t
checkType (Prod ts) = all okColT ts
checkType (Rec kts) = all okColT $ Map.elems kts
checkType _ = False

okColT :: T -> Bool
okColT (Array t) = okCellT t
okColT (Sequence t) = okCellT t
okColT (Nullable t) = okColT t
okColT _ = False

okRowT :: T -> Bool
okRowT (Rec kts) = all okCellT $ Map.elems kts
okRowT (Prod ts) = all okCellT ts
okRowT (Nullable t) = okRowT t
okRowT t = okCellT t

okCellT :: T -> Bool
okCellT (TCon tc) = Set.member tc cellPrims
okCellT (Enum _) = True
okCellT (Nullable t) = okCellT t
okCellT _ = False

cellPrims :: Set.Set Text
cellPrims = Set.fromList $ T.words "Int Double Text"