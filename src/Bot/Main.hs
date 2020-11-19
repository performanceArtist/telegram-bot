module Bot.Main (runBot) where

import           Control.Monad (forever)
import           Control.Monad.IO.Class (liftIO)
import           Control.Monad.Reader (asks)
import           Control.Monad.State (gets)
import           Control.Monad.State (get, put)
import           Data.Function ((&))
import           Data.IORef (readIORef, writeIORef)
import qualified Data.Set as Set
import           Network.HTTP.Req (GET (..), NoReqBody (..), lbsResponse, req,
                                   (=:))

import qualified Api.Get.Message
import           Bot.Handler.Main as Handler
import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.BotState as BotState
import qualified Bot.Model.Env as Env
import           Bot.Utils (findMessage, getChatID, getNewOffset, makeURL,
                            parseUpdates)

runBot :: Bot.Bot ()
runBot = forever $ do
  url <- asks $ makeURL ["getUpdates"]
  timeout <- asks Env.requestTimeout
  offset <- gets BotState.offset
  response <- req GET url NoReqBody lbsResponse $
    "offset" =: offset <> "timeout" =: timeout
  let updates = either (const []) id (parseUpdates response)
  updatesRef <- gets BotState.updates
  writeIORef updatesRef updates & liftIO
  show updates & print & liftIO
  handleOrIgnore (findMessage updates)
  state <- get
  put state { BotState.offset = getNewOffset updates offset }

handleOrIgnore :: Maybe Api.Get.Message.Message -> Bot.Bot ()
handleOrIgnore Nothing = return ()
handleOrIgnore (Just message) = do
  let chatID = getChatID message
  forkedChatIDsRef <- gets BotState.forkedChatIDs
  chatIDs <- liftIO $ readIORef forkedChatIDsRef
  if Set.member chatID chatIDs
    then return ()
    else Handler.handle message
