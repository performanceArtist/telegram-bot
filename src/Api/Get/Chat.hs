{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Chat where

import Data.Aeson
import GHC.Generics

data Chat = Chat {
  id :: Int,
  first_name :: String,
  last_name :: String
} deriving (Show, Generic, FromJSON, Eq)
