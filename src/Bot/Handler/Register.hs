module Bot.Handler.Register (register) where

import Data.Function ((&))
import Data.Maybe (maybe)

import qualified Api.Get.Message
import qualified Api.Post.Message
import Bot.Handler.Utils (textMessage, keyboardMessage)
import qualified Api.Post.Button as Button
import qualified Api.Get.Contact
import Bot.Poll (pollMessage, PollState(..))
import Bot.Utils (sendMessage)
import Bot.Model.Handler as BotHandler

register :: BotHandler.BotHandler
register message = do
  sendMessage $ keyboardMessage message keyboard "Send phone"
  phoneNumber <- pollMessage getPhone
  sendMessage $ textMessage message "Gib name"
  name <- pollMessage getName
  sendMessage $ textMessage message "Gib email"
  email <- pollMessage getEmail
  sendMessage $ textMessage message ("Oh yea: " ++ phoneNumber ++ name ++ email)

keyboard :: [[Button.Button]]
keyboard =
  [
    [
      Button.Button { Button.text = "Send your phone number", Button.request_contact = Just True }
    ]
  ]

noPhone :: Api.Get.Message.Message -> Api.Post.Message.Message
noPhone message = keyboardMessage message keyboard "I assure you, your phone number is vital to the success of this operation"

getPhone :: Api.Get.Message.Message -> PollState Api.Post.Message.Message String
getPhone message = do
  let phoneNumber = message & Api.Get.Message.contact & fmap Api.Get.Contact.phone_number
  maybe (message & noPhone & ContinueWith) EndWith phoneNumber

noName :: Api.Get.Message.Message -> Api.Post.Message.Message
noName message = textMessage message "No name"

getName :: Api.Get.Message.Message -> PollState Api.Post.Message.Message String
getName message = do
  let name = message & Api.Get.Message.text
  maybe (message & noName & ContinueWith) EndWith name

noEmail :: Api.Get.Message.Message -> Api.Post.Message.Message
noEmail message = textMessage message "Bad email"

getEmail :: Api.Get.Message.Message -> PollState Api.Post.Message.Message String
getEmail message = do
  let email = message & Api.Get.Message.text
  maybe (message & noEmail & ContinueWith) EndWith email
