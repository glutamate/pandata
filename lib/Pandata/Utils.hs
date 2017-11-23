module Pandata.Utils where

--TODO
incrementIdentifier :: String -> IO String
incrementIdentifier s =
  case reverse s of
    d1:d2:d3:_:rest -> s
    _ -> s