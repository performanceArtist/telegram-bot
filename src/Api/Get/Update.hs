{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Update where

import Data.Aeson
import GHC.Generics

import qualified Api.Get.Message as Message

data Update = Update {
  update_id :: Int,
  message :: Maybe Message.Message
} deriving (Show, Generic, FromJSON, Eq)
