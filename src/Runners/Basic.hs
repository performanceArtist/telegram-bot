module Runners.Basic (run) where

import Data.Either (either)
import Control.Arrow ((>>>))

import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.BotError as BotError
import qualified Bot.Model.Env as Env
import qualified Config.Model as Config
import Bot.Main (runBot)

run :: Config.Config -> IO ()
run config =
  Bot.run (runBot 0) Env.Env { Env.url = Config.url config, Env.token = Config.token config, Env.requestTimeout = 1 }
  >>= either (showError >>> print) (const (print "This should never happen"))

showError :: BotError.BotError -> String
showError (BotError.HTTPError error) = "HTTP error: " ++ error
showError BotError.InvalidResponse = "Failed to parse the response"
