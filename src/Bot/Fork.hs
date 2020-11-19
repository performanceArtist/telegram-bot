module Bot.Fork where

import qualified Bot.Model.Bot as Bot
import           Control.Concurrent (forkFinally)
import           Control.Monad.IO.Class (liftIO)
import           Control.Monad.Reader (ask)
import           Control.Monad.State (get, gets)
import           Data.Function ((&))
import           Data.Functor (void)
import           Data.IORef (modifyIORef, writeIORef)
import qualified Data.Set as Set

import qualified Api.Get.Message
import qualified Bot.Model.BotState as BotState
import qualified Bot.Model.Handler as BotHandler
import           Bot.Utils (getChatID)

forkHandler :: BotHandler.BotHandler -> Api.Get.Message.Message -> Bot.Bot ()
forkHandler handler message = do
  let chatID = getChatID message
  chatIDsRef <- gets BotState.forkedChatIDs
  updatesRef <- gets BotState.updates
  liftIO $ modifyIORef chatIDsRef (Set.insert chatID)
  liftIO $ writeIORef updatesRef []
  env <- ask
  state <- get
  let onDeath = \_ -> modifyIORef chatIDsRef (Set.delete chatID)
  _ <- Bot.run (handler message) env state & void & (\e -> forkFinally e onDeath) & liftIO
  return ()
