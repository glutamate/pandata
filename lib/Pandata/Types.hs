module Pandata.Types where

import Data.Text (Text)
import GHC.Generics
import Data.Word
import qualified Data.Vector as V

data T = TCon Text -- primitives
       | Enum [Text] -- enumeration types. E.g. sequence data
       | Array T
       | Sequence T -- streamable
       | Rec [(Text,T)]
       | Sum [T]
       | Prod [T]
       | Nullable T
  deriving (Generic, Show, Read, Eq)

data V = VInt Int | VBool Bool | VDouble Double | VText Text
       | VEnumText Text --if we dont yet know type
       | VEnumTag Word8
       | VArray (V.Vector V)



data Portal ds = Portal
  {

  }