{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Bot.Model.Bot (Bot(..), run) where

import Control.Monad.Reader
import Control.Monad.Except
import Control.Monad.State.Lazy
import Network.HTTP.Req

import qualified Bot.Model.Env as Env
import qualified Bot.Model.BotError as BotError
import Bot.Model.BotState (BotState)

newtype Bot a = Bot {
  runBot :: ReaderT Env.Env (ExceptT BotError.BotError (StateT BotState IO)) a
} deriving (Monad, Applicative, Functor, MonadReader Env.Env, MonadState BotState, MonadError BotError.BotError, MonadIO)

instance MonadHttp Bot where
  handleHttpException exception = throwError $ BotError.HTTPError $
    case exception of
      VanillaHttpException e -> show e
      JsonHttpException _ -> "Parsing error"

run :: Bot a -> Env.Env -> BotState -> IO (Either BotError.BotError a)
run program env initialState = evalStateT (runExceptT (runReaderT (runBot program) env)) initialState
