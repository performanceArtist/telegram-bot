module Bot.Handler.Quiz (quiz, quizNext) where

import Control.Monad.State (modify)
import qualified Data.HashMap.Strict as Map
import Data.Bool (bool)

import Bot.Model.Bot as Bot
import qualified Api.Get.Message
import qualified Api.Post.Message
import Bot.Handler.Utils (textMessage, keyboardMessage, getChatID)
import Bot.Parser.Model (Command(..))
import qualified Api.Post.Button as Button

quiz :: Api.Get.Message.Message -> Bot Api.Post.Message.Message
quiz message = do
  modify $ Map.insert (getChatID message) Quiz
  return $ keyboardMessage message keyboard "Wassup?"

rightAnswer :: String
rightAnswer = "Sup nigga"

keyboard :: [[Button.Button]]
keyboard =
  [
    [
      Button.Button { Button.text = "Nothing much" },
      Button.Button { Button.text = "Somebody once told me..." },
      Button.Button { Button.text = rightAnswer }
    ]
  ]

quizNext :: Api.Get.Message.Message -> Bot Api.Post.Message.Message
quizNext message = do
  modify $ Map.delete (getChatID message)
  let answer = Api.Get.Message.text message
  return $
    bool (textMessage message "Wrong answer man") (textMessage message "Oh yea") (answer == rightAnswer)
