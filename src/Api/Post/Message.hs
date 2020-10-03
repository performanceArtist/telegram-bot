{-# LANGUAGE DeriveAnyClass #-}

module Api.Post.Message where

import Data.Aeson
import GHC.Generics

import Api.Post.Keyboard as Keyboard

data Message = Message {
  chat_id :: Int,
  text :: String,
  reply_markup :: Keyboard.Keyboard
} deriving (Show, Generic, ToJSON)
