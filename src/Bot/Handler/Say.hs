module Bot.Handler.Say (sayGangsta) where

import System.Random (randomIO)
import Control.Monad (replicateM)
import Data.Char (toUpper)
import Data.Bool (bool)

sayGangsta :: String -> IO String
sayGangsta input = do
  indices <- makeBool (length input)
  return $ zipWith maybeToUpper indices input

maybeToUpper :: Bool -> Char -> Char
maybeToUpper isUpper character = bool character (toUpper character) isUpper

makeBool :: Int -> IO [Bool]
makeBool count = replicateM count randomIO
