module Bot.Handler.Utils where

import qualified Api.Post.Keyboard
import qualified Api.Post.Button
import qualified Api.Post.Message

makeMessage :: Int -> String -> Api.Post.Message.Message
makeMessage chatID text = Api.Post.Message.Message {
  Api.Post.Message.chat_id = chatID,
  Api.Post.Message.text = text,
  Api.Post.Message.reply_markup = Api.Post.Keyboard.Keyboard { Api.Post.Keyboard.keyboard = [] }
}
