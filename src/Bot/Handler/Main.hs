module Bot.Handler.Main (handle) where

import Data.Function ((&))
import Control.Arrow ((>>>))
import Data.Either (either)
import Control.Monad.Except (throwError)
import Control.Monad.IO.Class (liftIO)
import Data.Maybe (maybe)
import qualified Data.HashMap.Strict as Map
import Control.Monad.State (gets)

import qualified Api.Get.Message
import qualified Api.Get.Update
import qualified Api.Post.Message
import Bot.Handler.Utils (textMessage, getChatID)
import Bot.Parser.Main (parse)
import Bot.Parser.Model (Command(..), SayFlag(..))
import Bot.Model.Bot as Bot
import Bot.Model.BotError as BotError
import Bot.Handler.Start (startMessage)
import Bot.Handler.Say (sayGangsta)
import Bot.Handler.Quiz (quiz, quizNext)

handle :: Api.Get.Update.Update -> Bot.Bot Api.Post.Message.Message
handle update = do
  let noMessage = throwError (BotError.InvalidResponse "No message in update")
  message <- maybe noMessage return (update & Api.Get.Update.message)
  pendingCommand <- gets $ Map.lookup (getChatID message)
  maybe (handleMessage message) (handleNextMessage message) pendingCommand

handleMessage :: Api.Get.Message.Message -> Bot Api.Post.Message.Message
handleMessage message = either makeParseErrorMessage (handleCommandMessage message) command
  where
    command = message & Api.Get.Message.text & parse
    makeParseErrorMessage = show >>> (textMessage message) >>> return

handleCommandMessage :: Api.Get.Message.Message -> Command -> Bot Api.Post.Message.Message
handleCommandMessage message Start = return $ textMessage message startMessage
handleCommandMessage message (Say Echo content) = return $ textMessage message content
handleCommandMessage message (Say Gangsta content) = liftIO $ sayGangsta content & fmap (textMessage message)
handleCommandMessage message Quiz = quiz message

handleNextMessage :: Api.Get.Message.Message -> Command -> Bot Api.Post.Message.Message
handleNextMessage message Quiz = quizNext message
handleNextMessage message _ = throwError (BotError.LogicError "The supplied command isn't stateful")
