module Utils.List where

safeHead :: [a] -> Maybe a
safeHead []     = Nothing
safeHead (a:as) = Just a
