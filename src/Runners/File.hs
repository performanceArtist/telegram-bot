module Runners.File (run) where

import Data.Either (either)
import Control.Arrow ((>>>))

import qualified Bot.Model.Env as Env
import qualified Runners.Basic as Basic
import qualified Utils.File as File

run :: FilePath -> IO ()
run filepath = File.readJSON filepath >>= either (showError >>> print) Basic.run

showError :: File.ReadJSONError -> String
showError (File.ReadError _) = "IO Error"
showError (File.ParseError _) = "Failed to parse"
