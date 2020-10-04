module Bot.Handler.Utils where

import Control.Arrow ((>>>))

import qualified Api.Post.Keyboard
import qualified Api.Post.Button
import qualified Api.Post.Message
import qualified Api.Post.Keyboard
import qualified Api.Get.Message
import qualified Api.Get.Chat

getChatID :: Api.Get.Message.Message -> Int
getChatID = Api.Get.Message.chat >>> Api.Get.Chat.id

textMessage :: Api.Get.Message.Message -> String -> Api.Post.Message.Message
textMessage message text = Api.Post.Message.Message {
  Api.Post.Message.chat_id = getChatID message,
  Api.Post.Message.text = text,
  Api.Post.Message.reply_markup =
    Api.Post.Keyboard.Keyboard
      {
        Api.Post.Keyboard.keyboard = [],
        Api.Post.Keyboard.one_time_keyboard = True
      }
}

keyboardMessage :: Api.Get.Message.Message -> [[Api.Post.Button.Button]] -> String -> Api.Post.Message.Message
keyboardMessage message keyboard text = Api.Post.Message.Message {
  Api.Post.Message.chat_id = getChatID message,
  Api.Post.Message.text = text,
  Api.Post.Message.reply_markup =
    Api.Post.Keyboard.Keyboard {
      Api.Post.Keyboard.keyboard = keyboard,
      Api.Post.Keyboard.one_time_keyboard = True
    }
}
