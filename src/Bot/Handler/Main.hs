module Bot.Handler.Main (handle) where

import Data.Function ((&))
import Control.Arrow ((>>>))
import Data.Either (either)
import Control.Monad.Except (throwError)
import Control.Monad.IO.Class (liftIO)

import qualified Api.Get.Message
import qualified Api.Get.Chat
import qualified Api.Get.Update
import qualified Api.Post.Message
import Bot.Handler.Utils (makeMessage)
import Bot.Parser.Main (parse)
import Bot.Parser.Model (Command(..), SayFlag(..))
import Bot.Model.Bot as Bot
import Bot.Model.BotError as BotError
import Bot.Handler.Start (startMessage)
import Bot.Handler.Say (sayGangsta)

handle :: Api.Get.Update.Update -> Bot.Bot Api.Post.Message.Message
handle update = do
  let noMessage = throwError (BotError.InvalidResponse "No message in update")
  message <- maybe noMessage return (update & Api.Get.Update.message)
  let chatID = message & Api.Get.Message.chat & Api.Get.Chat.id
  text <- message & Api.Get.Message.text & getMessageText
  return $ makeMessage chatID text

getMessageText :: String -> Bot String
getMessageText text = either (show >>> return) fromCommand (parse text)

fromCommand :: Command -> Bot String
fromCommand Start = return startMessage
fromCommand (Say Echo content) = return content
fromCommand (Say Gangsta content) = liftIO (sayGangsta content)
