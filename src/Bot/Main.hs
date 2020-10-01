module Bot.Main (runBot) where

import Data.Function ((&))
import Control.Arrow ((>>>))
import Control.Monad.Reader (asks)
import Data.Bifunctor as Bifunctor
import Data.Aeson as Aeson
import Network.HTTP.Req
  (
    req,
    NoReqBody(..),
    lbsResponse,
    responseBody,
    GET(..),
    POST(..),
    (/:),
    Url(),
    Scheme(..),
    https,
    (=:),
    ReqBodyJson(..),
    LbsResponse(..)
  )
import Data.Either (either)
import Control.Monad.Except (throwError)
import Data.Text (pack)
import Data.Monoid ((<>))
import Data.Bool (bool)

import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.Env as Env
import qualified Bot.Model.BotError as BotError
import qualified Api.Get.Response
import qualified Api.Get.Update
import qualified Utils.Either
import Bot.Handler.Main as Handler

runBot :: Int -> Bot.Bot [String]
runBot offset = do
  baseURL <- asks getBaseURL
  timeout <- asks Env.requestTimeout
  let url = baseURL /: ("getUpdates" & pack)
  response <- req GET url NoReqBody lbsResponse $
    "offset" =: offset <> "timeout" =: timeout
  let updates = getUpdates response
  either throwError (traverse respond) updates
  runBot (either (const 0) getNewOffset updates)

getBaseURL :: Env.Env -> Url 'Https
getBaseURL env = https base /: token
  where
    base = env & Env.url & pack
    token = env & Env.token & pack

getUpdates :: LbsResponse -> Either BotError.BotError [Api.Get.Update.Update]
getUpdates response =
  responseBody response
  & Aeson.eitherDecode
  & Bifunctor.first (const BotError.InvalidResponse)
  >>= getResponseResult

getResponseResult :: Api.Get.Response.Response -> Either BotError.BotError [Api.Get.Update.Update]
getResponseResult =
  Utils.Either.fromPredicate Api.Get.Response.ok (const BotError.EmbeddedResponseError)
  >>> fmap Api.Get.Response.result

respond :: Api.Get.Update.Update -> Bot.Bot String
respond update = do
  baseURL <- asks getBaseURL
  let url = baseURL /: ("sendMessage" & pack)
  let message = update & Handler.handle & ReqBodyJson
  response <- req POST url message lbsResponse mempty
  return $ response & responseBody & show

getNewOffset :: [Api.Get.Update.Update] -> Int
getNewOffset [] = 0
getNewOffset update = last update & Api.Get.Update.update_id & (+1)
