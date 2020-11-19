module Runners.Basic (run) where

import           Control.Arrow ((>>>))
import           Data.Either (either)
import           Data.IORef (newIORef)
import qualified Data.Set as Set

import           Bot.Main (runBot)
import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.BotError as BotError
import qualified Bot.Model.BotState as BotState
import qualified Bot.Model.Env as Env
import qualified Config.Model as Config

run :: Config.Config -> IO ()
run config = do
  updates <- newIORef []
  forkedChatIDs <- newIORef Set.empty
  let env = Env.Env { Env.url = Config.url config, Env.token = Config.token config, Env.requestTimeout = 1 }
  let state = BotState.BotState {
      BotState.offset = 0,
      BotState.updates = updates,
      BotState.forkedChatIDs = forkedChatIDs
    }
  result <- Bot.run runBot env state
  either (showError >>> print) (const (print "This should never happen")) result

showError :: BotError.BotError -> String
showError (BotError.HTTPError error) = "HTTP error: " ++ error
showError (BotError.InvalidResponse response) = "Failed to parse the response: " ++ response
showError (BotError.EmbeddedResponseError) = "Response error"
showError _ = "Error"
