module Bot.Model.Env (Env(..)) where

data Env = Env {
  url            :: String,
  token          :: String,
  requestTimeout :: Int
}
