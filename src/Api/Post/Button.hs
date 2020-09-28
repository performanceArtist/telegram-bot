{-# LANGUAGE DeriveAnyClass #-}

module Api.Post.Button where

import Data.Aeson
import GHC.Generics

data Button = Button {
  text :: String
} deriving (Show, Generic, ToJSON)
