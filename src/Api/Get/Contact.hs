{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Contact where

import           Data.Aeson
import           GHC.Generics

data Contact = Contact {
  phone_number :: String,
  first_name   :: String
} deriving (Show, Generic, FromJSON, Eq)
