module Bot.Handler.Utils where

import Data.Function ((&))

import qualified Api.Post.Keyboard
import qualified Api.Post.Button
import qualified Api.Post.Message
import qualified Api.Get.Message
import qualified Bot.Model.BotState as BotState
import Bot.Utils (getChatID)

textMessage :: Api.Get.Message.Message -> String -> Api.Post.Message.Message
textMessage message text = Api.Post.Message.Message {
  Api.Post.Message.chat_id = message & getChatID & BotState.toInt,
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
  Api.Post.Message.chat_id = message & getChatID & BotState.toInt,
  Api.Post.Message.text = text,
  Api.Post.Message.reply_markup =
    Api.Post.Keyboard.Keyboard {
      Api.Post.Keyboard.keyboard = keyboard,
      Api.Post.Keyboard.one_time_keyboard = True
    }
}

plainButton :: String -> Api.Post.Button.Button
plainButton text = Api.Post.Button.Button { Api.Post.Button.text = text, Api.Post.Button.request_contact = Nothing }
