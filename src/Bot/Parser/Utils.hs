module Bot.Parser.Utils where

import           Control.Applicative ((*>), (<*))
import           Data.Function ((&))
import           Data.Functor (void)
import           Text.Parsec (ParseError, many, parse, string)
import           Text.Parsec.Char (oneOf)
import           Text.Parsec.Combinator (eof)
import           Text.Parsec.String (Parser)

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
