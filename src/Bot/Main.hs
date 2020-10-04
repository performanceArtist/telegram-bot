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
import Control.Monad.Except (throwError, catchError)
import Data.Text (pack)
import Data.Monoid ((<>))
import Data.Bool (bool)
import Data.Foldable (traverse_)
import Data.Functor (void)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.State (get)

import qualified Bot.Model.Bot as Bot
import qualified Bot.Model.Env as Env
import qualified Bot.Model.BotError as BotError
import qualified Api.Get.Response
import qualified Api.Get.Update
import qualified Api.Post.Message
import qualified Utils.Either
import Bot.Handler.Main as Handler

runBot :: Int -> Bot.Bot ()
runBot offset = do
  url <- asks $ makeURL ["getUpdates"]
  timeout <- asks Env.requestTimeout
  response <- req GET url NoReqBody lbsResponse $
    "offset" =: offset <> "timeout" =: timeout
  let updates = parseResponse response >>= getResponseResult
  state <- get
  liftIO $ print $ show updates ++ " State: " ++ show state
  either (const (return ())) (traverse_ respond) updates
  runBot (either (const 0) getNewOffset updates)

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

respond :: Api.Get.Update.Update -> Bot.Bot ()
respond update = do
  url <- asks $ makeURL ["sendMessage"]
  message <- update & Handler.handle & recover
  let onMessage = (\message -> void $ req POST url (ReqBodyJson message) lbsResponse mempty)
  maybe (return ()) onMessage message

recover :: Bot.Bot Api.Post.Message.Message -> Bot.Bot (Maybe Api.Post.Message.Message)
recover message = catchError (fmap Just message) (const (return Nothing))

getNewOffset :: [Api.Get.Update.Update] -> Int
getNewOffset [] = 0
getNewOffset update = last update & Api.Get.Update.update_id & (+1)
