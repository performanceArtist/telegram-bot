module Bot.Message (fromUpdate) where

import Data.Function ((&))

import qualified Api.Get.Update
import qualified Api.Get.Message
import qualified Api.Get.Chat
import qualified Api.Post.Keyboard
import qualified Api.Post.Button
import qualified Api.Post.Message

makeMessage :: Int -> String -> Api.Post.Message.Message
makeMessage chatID text = Api.Post.Message.Message {
  Api.Post.Message.chat_id = chatID,
  Api.Post.Message.text = text,
  Api.Post.Message.reply_markup = Api.Post.Keyboard.Keyboard { Api.Post.Keyboard.keyboard = [[]] }
}

fromUpdate :: Api.Get.Update.Update -> Api.Post.Message.Message
fromUpdate update = makeMessage chatID text
  where
    chatID = update & Api.Get.Update.message & Api.Get.Message.chat & Api.Get.Chat.id
    text = "Ok"
