module Bot.Model.BotError where

data BotError = InvalidResponse | HTTPError String | EmbeddedResponseError deriving (Show)
