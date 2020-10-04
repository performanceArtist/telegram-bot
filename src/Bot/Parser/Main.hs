module Bot.Parser.Main (parse) where

import Text.Parsec.String (Parser)
import Text.Parsec (ParseError, (<|>), try)

import Bot.Parser.Model (Command(..))
import Bot.Parser.Utils (parseWithWhitespace)
import Bot.Parser.Say (say)
import Bot.Parser.Start (start)
import Bot.Parser.Quiz (quiz)

parser :: Parser Command
parser = try start <|> try say <|> quiz

parse :: String -> Either ParseError Command
parse input = parseWithWhitespace parser input
