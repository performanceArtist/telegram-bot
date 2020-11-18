{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Message where

import Data.Aeson
import GHC.Generics

import qualified Api.Get.From as From
import qualified Api.Get.Chat as Chat
import qualified Api.Get.Contact as Contact

data Message = Message {
  message_id :: Int,
  from :: From.From,
  chat :: Chat.Chat,
  date :: Int,
  text :: Maybe String,
  contact :: Maybe Contact.Contact
} deriving (Show, Generic, FromJSON, Eq)
