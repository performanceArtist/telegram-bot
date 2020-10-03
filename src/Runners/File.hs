module Runners.File (run) where

import Data.Either (either)
import Control.Arrow ((>>>))

import qualified Bot.Model.Env as Env
import qualified Runners.Basic as Basic
import qualified Utils.File as File

run :: FilePath -> IO ()
run filepath = File.readJSON filepath >>= either (showError >>> print) Basic.run

showError :: File.ReadJSONError -> String
showError (File.ReadError error) = "Error reading the config: " ++ (show error)
showError (File.ParseError error) = "Failed to parse the config: " ++ (show error)
