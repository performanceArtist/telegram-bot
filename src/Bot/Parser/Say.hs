module Bot.Parser.Say (say) where

import Text.Parsec.String (Parser)
import Text.Parsec (many1, try, (<|>))
import Text.Parsec.Char (anyChar)

import Bot.Parser.Model (Command(..), SayFlag(..))
import Bot.Parser.Utils (parseWithWhitespace, makeFlag, makeCommand, lexeme)

gangsta :: Parser SayFlag
gangsta = do
  lexeme $ makeFlag "gangsta"
  return Gangsta

echo :: Parser SayFlag
echo = do
  lexeme $ makeFlag "echo"
  return Echo

anyFlag :: Parser SayFlag
anyFlag = (try gangsta) <|> (try echo) <|> (return Gangsta)

say :: Parser Command
say = do
  lexeme $ makeCommand "say"
  flag <- anyFlag
  content <- lexeme $ many1 anyChar
  return $ Say flag content
