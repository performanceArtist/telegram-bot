module Bot.Handler.Main (handle) where

import           Control.Arrow ((>>>))
import           Control.Monad.IO.Class (liftIO)
import           Data.Bifunctor as Bifunctor
import           Data.Either (either)
import           Data.Function ((&))

import qualified Api.Get.Message
import           Bot.Fork (forkHandler)
import           Bot.Handler.Quiz (quiz)
import           Bot.Handler.Register (register)
import           Bot.Handler.Say (sayGangsta)
import           Bot.Handler.Start (startMessage)
import           Bot.Handler.Utils (textMessage)
import           Bot.Model.Bot as Bot
import           Bot.Model.Handler as BotHandler
import           Bot.Parser.Main (parse)
import           Bot.Parser.Model (Command (..), SayFlag (..))
import           Bot.Utils (sendMessage)
import           Utils.Either (fromMaybe)

handle :: BotHandler.BotHandler
handle message = either makeParseErrorMessage (handleCommandMessage message) command
  where
    command = message & Api.Get.Message.text & fromMaybe "No text" >>= (parse >>> Bifunctor.first show)
    makeParseErrorMessage = (textMessage message) >>> sendMessage

handleCommandMessage :: Api.Get.Message.Message -> Command -> Bot ()
handleCommandMessage message Start = sendMessage $ textMessage message startMessage
handleCommandMessage message (Say Echo content) = sendMessage $ textMessage message content
handleCommandMessage message (Say Gangsta content) = (liftIO $ sayGangsta content & fmap (textMessage message)) >>= sendMessage
handleCommandMessage message Quiz = forkHandler quiz message
handleCommandMessage message Register = forkHandler register message
