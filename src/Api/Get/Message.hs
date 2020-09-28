{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Message where

import Data.Aeson
import GHC.Generics

import qualified Api.Get.From as From
import qualified Api.Get.Chat as Chat

data Message = Message {
  message_id :: Int,
  from :: From.From,
  chat :: Chat.Chat,
  date :: Int,
  text :: String
} deriving (Show, Generic, FromJSON, Eq)
