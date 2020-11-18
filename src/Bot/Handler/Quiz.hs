module Bot.Handler.Quiz (quiz) where

import qualified Api.Get.Message
import qualified Api.Post.Message
import Bot.Handler.Utils (textMessage, keyboardMessage, plainButton)
import qualified Api.Post.Button as Button
import Bot.Utils (sendMessage)
import Bot.Poll (pollMessage, PollState(..))
import Bot.Model.Handler as BotHandler

quiz :: BotHandler.BotHandler
quiz message = do
  sendMessage $ keyboardMessage message keyboard "Wassup?"
  answer <- pollMessage getAnswer
  sendMessage $ textMessage message answer

rightAnswer :: String
rightAnswer = "Sup"

keyboard :: [[Button.Button]]
keyboard =
  [
    [
      plainButton "Nothing much",
      plainButton "Somebody once told me...",
      plainButton rightAnswer
    ]
  ]

getAnswer :: Api.Get.Message.Message -> PollState Api.Post.Message.Message String
getAnswer message =
  if Api.Get.Message.text message == (Just rightAnswer)
    then EndWith $ "Wrong answer man"
    else EndWith $ "Oh yea"
