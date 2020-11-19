{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.From where

import           Data.Aeson
import           GHC.Generics

data From = From {
  id            :: Int,
  is_bot        :: Bool,
  first_name    :: String,
  last_name     :: String,
  language_code :: String
} deriving (Show, Generic, FromJSON, Eq)
