module Bot.Fork where

import qualified Bot.Model.Bot as Bot
import           Control.Concurrent (forkFinally)
import           Control.Monad.Except (catchError)
import           Control.Monad.IO.Class (liftIO)
import           Control.Monad.Reader (ask)
import           Control.Monad.State (get, gets)
import           Data.Function ((&))
import           Data.IORef (modifyIORef, writeIORef)
import qualified Data.Set as Set

import qualified Api.Get.Message
import           Bot.Model.BotError as BotError
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
  let program = catchError (handler message) reportError
  let cleanup = const $ modifyIORef chatIDsRef (Set.delete chatID)
  env <- ask
  state <- get
  Bot.run program env state & (\action -> forkFinally action cleanup) & liftIO
  return ()

reportError :: BotError.BotError -> Bot.Bot ()
reportError e = ("Error in thread: " ++ show e) & print & liftIO
