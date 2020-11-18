module Bot.Model.Handler where

import qualified Api.Get.Message
import Bot.Model.Bot (Bot())

type BotHandler = Api.Get.Message.Message -> Bot ()
