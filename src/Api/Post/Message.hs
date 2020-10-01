{-# LANGUAGE DeriveAnyClass #-}

module Api.Post.Message where

import Data.Aeson
import GHC.Generics

data Message = Message {
  chat_id :: Int,
  text :: String
} deriving (Show, Generic, ToJSON)
