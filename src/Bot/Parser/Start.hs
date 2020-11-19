module Bot.Parser.Start where

import           Text.Parsec.String (Parser)

import           Bot.Parser.Model (Command (..))
import           Bot.Parser.Utils (makeCommand)

start :: Parser Command
start = do
  _ <- makeCommand "start"
  return Start
