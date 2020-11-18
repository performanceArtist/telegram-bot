module Bot.Poll where

import Control.Monad.State (get, gets, put)
import Control.Arrow ((>>>))
import Data.Maybe (maybe)
import Data.IORef (readIORef)
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (threadDelay)

import Bot.Utils (getNewOffset, sendMessage, findMessage)
import qualified Bot.Model.Bot as Bot
import qualified Api.Get.Update
import qualified Api.Post.Message
import qualified Bot.Model.BotState as BotState
import qualified Api.Get.Message

data PollState a b = Continue | ContinueWith a | EndWith b

pollState :: ([Api.Get.Update.Update] -> PollState Api.Post.Message.Message b) -> Bot.Bot b
pollState f = do
  liftIO $ threadDelay 100
  updatesRef <- gets BotState.updates
  updates <- liftIO $ readIORef updatesRef
  oldOffset <- gets BotState.offset
  let newOffset = getNewOffset updates oldOffset
  if newOffset == oldOffset
    then pollState f
    else do
      state <- get
      put state { BotState.offset = newOffset }
      case (f updates) of
        EndWith message -> return message
        Continue -> pollState f
        ContinueWith message -> do
          sendMessage message
          pollState f

pollMessage :: (Api.Get.Message.Message -> PollState Api.Post.Message.Message b) -> Bot.Bot b
pollMessage f = pollState $ findMessage >>> (maybe Continue f)
