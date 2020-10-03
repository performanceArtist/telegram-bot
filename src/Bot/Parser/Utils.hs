module Bot.Parser.Utils where

import Text.Parsec (ParseError, parse, many, string, (<?>))
import Text.Parsec.String (Parser)
import Control.Applicative ((<*>), (<*), (*>))
import Text.Parsec.Combinator (eof)
import Text.Parsec.Char (oneOf, char)
import Data.Functor (void)
import Data.Function ((&))

parseBasic :: Parser a -> String -> Either ParseError a
parseBasic parser = parse parser ""

parseWithEof :: Parser a -> String -> Either ParseError a
parseWithEof parser = parse (parser <* eof) ""

whitespace :: Parser ()
whitespace = void $ many (oneOf " \n\t")

lexeme :: Parser a -> Parser a
lexeme parser = parser <* whitespace

parseWithWhitespace :: Parser a -> String -> Either ParseError a
parseWithWhitespace parser = (whitespace *> parser) & parseWithEof

makeCommand :: String -> Parser String
makeCommand command = string ("/" ++ command)

makeFlag :: String -> Parser String
makeFlag name = string ("&" ++ name)
