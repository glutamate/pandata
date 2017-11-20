module Pandata.Types where

import Data.Text (Text)
import GHC.Generics
import Data.Word
import qualified Data.Vector as V
import qualified Data.Map.Strict as Map
import Data.Map (Map)
import qualified Data.Set as Set
import Data.Set (Set)
import qualified Streaming.Prelude as S
import Streaming.Prelude (Stream, Of)
import Data.ByteString (ByteString)



data T = TCon Text -- primitives
       | Enum (Set Text) -- enumeration types. E.g. sequence data
       | Array T
       | Sequence T -- streamable
       | Rec (Map Text T)
       | Sum [T]
       | Prod [T]
       | Nullable T
  deriving (Generic, Show, Read, Eq)

data V = VInt Int | VBool Bool | VDouble Double | VText Text
       | VEnumText Text --if we dont yet know type
       | VEnumTag Word8
       | VArray (V.Vector V)
       | VSeq (Stream (Of V) IO ())
       | VRec (Map Text V)
       | VSum Int V
       | VProd [V]
       | VNull
       | VBS ByteString

--cannot be represented as a ByteString
hasSeq :: T -> Bool
hasSeq (Sequence _) = True
hasSeq (Array t) = hasSeq t
hasSeq (Nullable t) = hasSeq t
hasSeq (Rec kts) = any hasSeq $ Map.elems kts
hasSeq (Sum ts) = any hasSeq ts
hasSeq (Prod ts) = any hasSeq ts
hasSeq (Enum _) = False
hasSeq (TCon _) = False

data Portal ds = Portal
  {

  }