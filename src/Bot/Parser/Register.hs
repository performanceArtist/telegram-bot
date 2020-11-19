 module Bot.Parser.Register where

import           Text.Parsec.String (Parser)

import           Bot.Parser.Model (Command (..))
import           Bot.Parser.Utils (makeCommand)

register :: Parser Command
register = do
  _ <- makeCommand "register"
  return Register
