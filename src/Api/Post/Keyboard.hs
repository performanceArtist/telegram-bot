{-# LANGUAGE DeriveAnyClass #-}

module Api.Post.Keyboard where

import Data.Aeson
import GHC.Generics

import qualified Api.Post.Button as Button

data Keyboard = Keyboard {
  keyboard :: [[Button.Button]]
} deriving (Show, Generic, ToJSON)
