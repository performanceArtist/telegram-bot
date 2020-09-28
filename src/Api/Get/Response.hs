{-# LANGUAGE DeriveAnyClass #-}

module Api.Get.Response where

import Data.Aeson
import GHC.Generics

import qualified Api.Get.Update as Update

data Response = Response {
  ok :: Bool,
  result :: [Update.Update]
} deriving (Show, Generic, FromJSON, Eq)
