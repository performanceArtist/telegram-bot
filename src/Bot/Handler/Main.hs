module Bot.Handler.Main (handle) where

import Data.Function ((&))
import Control.Arrow ((>>>))
import Data.Either (either)
import Control.Monad.IO.Class (liftIO)
import Data.Bifunctor as Bifunctor

import qualified Api.Get.Message
import Bot.Parser.Main (parse)
import Bot.Parser.Model (Command(..), SayFlag(..))
import Bot.Model.Bot as Bot
import Bot.Model.Handler as BotHandler
import Bot.Handler.Start (startMessage)
import Bot.Handler.Say (sayGangsta)
import Bot.Handler.Quiz (quiz)
import Bot.Handler.Register (register)
import Utils.Either (fromMaybe)
import Bot.Utils (sendMessage)
import Bot.Handler.Utils (textMessage)
import Bot.Fork (forkHandler)

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
