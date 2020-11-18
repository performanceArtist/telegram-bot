module Bot.Parser.Model where

data SayFlag = Echo | Gangsta deriving (Show)

data Command = Start | Say SayFlag String | Quiz | Register deriving (Show)
