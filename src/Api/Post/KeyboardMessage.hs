{-# LANGUAGE DeriveAnyClass #-}

module Api.Post.KeyboardMessage where

import Data.Aeson
import GHC.Generics

import qualified Api.Post.Keyboard as Keyboard

data KeyboardMessage = KeyboardMessage {
  chat_id :: Int,
  text :: String,
  reply_markup :: Keyboard.Keyboard
} deriving (Show, Generic, ToJSON)
