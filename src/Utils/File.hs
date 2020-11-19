module Utils.File (safeReadFile, readJSON, ReadJSONError(..)) where

import           Control.Arrow ((>>>))
import           Control.Exception (try)
import           Data.Aeson (FromJSON, eitherDecode)
import qualified Data.Bifunctor as Bifunctor
import qualified Data.ByteString.Lazy.Char8 as BSL
import           Data.Function ((&))

safeReadFile :: FilePath -> IO (Either IOError String)
safeReadFile= readFile >>> try

data ReadJSONError = ReadError IOError | ParseError String

readJSON :: FromJSON a => FilePath -> IO (Either ReadJSONError a)
readJSON filepath = do
  content <- filepath & safeReadFile & fmap (Bifunctor.first ReadError)
  return $ content >>= (BSL.pack >>> eitherDecode >>> Bifunctor.first ParseError)
