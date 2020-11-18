module Bot.Model.BotError where

import qualified Api.Post.Message

data BotError = InvalidResponse String | HTTPError String | EmbeddedResponseError | LogicError String | UserError Api.Post.Message.Message deriving (Show)
