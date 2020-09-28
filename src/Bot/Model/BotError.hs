module Bot.Model.BotError where

data BotError = InvalidResponse | HTTPError String deriving (Show)
