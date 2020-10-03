{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Bot.Model.Bot (Bot(..), run) where

import Control.Monad.Reader
import Control.Monad.Except
import Network.HTTP.Req

import qualified Bot.Model.Env as Env
import qualified Bot.Model.BotError as BotError

newtype Bot a = Bot {
  runBot :: ReaderT Env.Env (ExceptT BotError.BotError IO) a
} deriving (Monad, Applicative, Functor, MonadReader Env.Env, MonadError BotError.BotError, MonadIO)

instance MonadHttp Bot where
  handleHttpException exception = throwError $ BotError.HTTPError $
    case exception of
      VanillaHttpException error -> show error
      JsonHttpException error -> "Parsing error"

run :: Bot a -> Env.Env -> IO (Either BotError.BotError a)
run program env = runExceptT (runReaderT (runBot program) env)
