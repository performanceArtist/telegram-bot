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
    ReqBodyJson(..)
  )
import Data.Either (either)
import Control.Monad.Except (throwError)
import Data.Text (pack)
import Data.Monoid ((<>))

import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.Env as Env
import qualified Bot.Model.BotError as BotError
import qualified Api.Get.Response
import qualified Api.Get.Update
import Bot.Message (fromUpdate)

getBaseURL :: Env.Env -> Url 'Https
getBaseURL env = https base /: token
  where
    base = env & Env.url & pack
    token = env & Env.token & pack

runBot :: Int -> Bot.Bot [String]
runBot offset = do
  baseURL <- asks getBaseURL
  timeout <- asks Env.requestTimeout
  let url = baseURL /: ("getUpdates" & pack)
  response <- req GET url NoReqBody lbsResponse $
    "offset" =: offset <> "timeout" =: timeout
  let updates =
       responseBody response
       & Aeson.eitherDecode
       & Bifunctor.bimap (const BotError.InvalidResponse) Api.Get.Response.result
  either throwError (traverse respond) updates
  runBot (either (const 0) getLastOffset updates)

getLastOffset :: [Api.Get.Update.Update] -> Int
getLastOffset [] = 0
getLastOffset x = (Api.Get.Update.update_id (last x)) + 1

respond :: Api.Get.Update.Update -> Bot.Bot String
respond update = do
  baseURL <- asks getBaseURL
  let url = baseURL /: ("sendMessage" & pack)
  let message = update & fromUpdate & ReqBodyJson
  response <- req POST url message lbsResponse mempty
  return $ response & responseBody & show
