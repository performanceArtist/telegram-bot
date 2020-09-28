module Main where

import Runners.File (run)

main :: IO ()
main = run "./static/config.json"
