module Bot.Utils where

import Network.HTTP.Req
import Data.Text (pack)
import Data.Bifunctor as Bifunctor
import Data.Aeson as Aeson
import Data.Function ((&))
import Control.Arrow ((>>>))
import Control.Monad.Reader (asks)
import Data.Functor (void)
import Control.Applicative ((<|>))

import qualified Bot.Model.Env as Env
import qualified Api.Get.Update
import qualified Api.Post.Message
import qualified Api.Get.Message
import qualified Bot.Model.BotError as BotError
import qualified Api.Get.Response
import qualified Utils.Either
import Bot.Model.Bot as Bot
import qualified Bot.Model.BotState as BotState
import qualified Api.Get.Chat

makeURL :: [String] -> Env.Env -> Url 'Https
makeURL parts env = foldl (/:) baseURL lbsParts
  where
    base = env & Env.url & pack
    token = env & Env.token & pack
    baseURL = https base /: token
    lbsParts = fmap pack parts

parseResponse :: LbsResponse -> Either BotError.BotError Api.Get.Response.Response
parseResponse =
  responseBody
  >>> Aeson.eitherDecode
  >>> Bifunctor.first (show >>> BotError.InvalidResponse)

getResponseResult :: Api.Get.Response.Response -> Either BotError.BotError [Api.Get.Update.Update]
getResponseResult =
  Utils.Either.fromPredicate Api.Get.Response.ok (const BotError.EmbeddedResponseError)
  >>> fmap Api.Get.Response.result

parseUpdates :: LbsResponse -> Either BotError.BotError [Api.Get.Update.Update]
parseUpdates r = (parseResponse r) >>= getResponseResult

getNewOffset :: [Api.Get.Update.Update] -> Int -> Int
getNewOffset [] oldOffset = oldOffset
getNewOffset update _ = last update & Api.Get.Update.update_id & (+1)

sendMessage :: Api.Post.Message.Message -> Bot.Bot ()
sendMessage message = do
  url <- asks $ makeURL ["sendMessage"]
  void $ req POST url (ReqBodyJson message) lbsResponse mempty

findMessage :: [Api.Get.Update.Update] -> Maybe Api.Get.Message.Message
findMessage [] = Nothing
findMessage (u:us) = Api.Get.Update.message u <|> (findMessage us)

getChatID :: Api.Get.Message.Message -> BotState.ChatID
getChatID = Api.Get.Message.chat >>> Api.Get.Chat.id >>> BotState.ChatID
