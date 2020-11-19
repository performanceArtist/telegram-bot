{-# LANGUAGE DeriveAnyClass #-}

module Config.Model where

import           Data.Aeson
import           GHC.Generics

data Config = Config {
  url   :: String,
  token :: String
} deriving (Show, Generic, ToJSON, FromJSON)
