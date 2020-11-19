module Bot.Parser.Main (parse) where

import           Text.Parsec (ParseError, try, (<|>))
import           Text.Parsec.String (Parser)

import           Bot.Parser.Model (Command (..))
import           Bot.Parser.Quiz (quiz)
import           Bot.Parser.Register (register)
import           Bot.Parser.Say (say)
import           Bot.Parser.Start (start)
import           Bot.Parser.Utils (parseWithWhitespace)

parser :: Parser Command
parser = try start <|> try say <|> try quiz <|> register

parse :: String -> Either ParseError Command
parse input = parseWithWhitespace parser input
