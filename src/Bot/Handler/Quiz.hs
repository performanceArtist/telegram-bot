module Bot.Handler.Quiz (quiz) where

import qualified Api.Get.Message
import qualified Api.Post.Button as Button
import qualified Api.Post.Message
import           Bot.Handler.Utils (keyboardMessage, plainButton, textMessage)
import           Bot.Model.Handler as BotHandler
import           Bot.Poll (PollState (..), makePollMessage)
import           Bot.Utils (getChatID, sendMessage)

quiz :: BotHandler.BotHandler
quiz message = do
  let pollMessage = makePollMessage (getChatID message)
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
    then EndWith $ "Oh yea"
    else EndWith $ "Wrong answer man"
