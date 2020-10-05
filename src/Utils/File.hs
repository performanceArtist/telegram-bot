module Utils.File (safeReadFile, readJSON, ReadJSONError(..)) where

import Control.Exception (try)
import Control.Arrow ((>>>))
import Data.Function ((&))
import qualified Data.Bifunctor as Bifunctor
import qualified Data.ByteString.Lazy.Char8 as BSL
import Data.Aeson (eitherDecode, FromJSON())

safeReadFile :: FilePath -> IO (Either IOError String)
safeReadFile= readFile >>> try

data ReadJSONError = ReadError IOError | ParseError String

readJSON :: FromJSON a => FilePath -> IO (Either ReadJSONError a)
readJSON filepath = do
  content <- filepath & safeReadFile & fmap (Bifunctor.first ReadError)
  return $ content >>= (BSL.pack >>> eitherDecode >>> Bifunctor.first ParseError)
