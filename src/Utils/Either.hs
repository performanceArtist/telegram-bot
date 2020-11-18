module Utils.Either where

import Data.Bool (bool)

fromPredicate :: (a -> Bool) -> (a -> b) -> a -> Either b a
fromPredicate predicate fallback value = bool (Left (fallback value)) (Right value) (predicate value)

fromMaybe :: e -> Maybe a -> Either e a
fromMaybe e Nothing = Left e
fromMaybe _ (Just value) = Right value
