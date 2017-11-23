module Pandata.Format.CSV (csvFmt) where

import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Map.Strict as Map
import Pandata.Types
import Data.Csv
import qualified Data.Set as Set
import System.Directory
import System.FilePath
import System.IO

csvFmt :: DataFormat FilePath
csvFmt = DataFormat
  { isTypeWritable = checkType
  , knownExtensions = Set.fromList ["csv"]
  , newDataset = getNewFile
  }

writeFile:: FilePath-> T-> V-> IO ()
writeFile fp t v = withFile fp WriteMode $ \h -> writeAll h t v
  
writeAll h (Sequence (Rec nmts)) v = writeHeader h nmts
writeAll h (Array (Rec nmts)) v = writeHeader h nmts

writeHeader h = T.hPutStrLn h . T.intercalate "," . Map.keys 

getNewFile :: FilePath -> T -> IO FilePath
getNewFile fp _ = do
  ex <- doesFileExist fp
  if ex 
    then return fp -- TO DO increment file name
    else return fp


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