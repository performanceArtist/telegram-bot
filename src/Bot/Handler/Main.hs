module Bot.Handler.Main (handle) where

import Data.Function ((&))

import qualified Api.Get.Message
import qualified Api.Get.Chat
import qualified Api.Get.Update
import qualified Api.Post.Message
import Bot.Handler.Utils (makeMessage)

handle :: Api.Get.Update.Update -> Api.Post.Message.Message
handle update = makeMessage chatID text
  where
    message = update & Api.Get.Update.message
    chatID = message & Api.Get.Message.chat & Api.Get.Chat.id
    text = message & Api.Get.Message.text
