module Runners.Basic (run) where

import Data.Either (either)
import Control.Arrow ((>>>))
import Data.HashMap.Strict (empty)

import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.BotError as BotError
import qualified Bot.Model.Env as Env
import qualified Config.Model as Config
import Bot.Main (runBot)

run :: Config.Config -> IO ()
run config =
  Bot.run (runBot 0) env state
  >>= either (showError >>> print) (const (print "This should never happen"))
    where
      env = Env.Env { Env.url = Config.url config, Env.token = Config.token config, Env.requestTimeout = 1 }
      state = empty

showError :: BotError.BotError -> String
showError (BotError.HTTPError error) = "HTTP error: " ++ error
showError (BotError.InvalidResponse response) = "Failed to parse the response: " ++ response
