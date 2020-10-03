module Bot.Model.BotError where

data BotError = InvalidResponse String | HTTPError String | EmbeddedResponseError deriving (Show)
