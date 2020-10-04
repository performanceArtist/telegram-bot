module Bot.Parser.Quiz where

import Text.Parsec.String (Parser)

import Bot.Parser.Model (Command(..))
import Bot.Parser.Utils (makeCommand)

quiz :: Parser Command
quiz = do
  makeCommand "quiz"
  return Quiz
