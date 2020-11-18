module Bot.Handler.Start (startMessage) where

startMessage :: String
startMessage =
  unlines $ [
    "Wuss poppin' B?",
    "/start",
    "/say &(echo|gangsta) <text>",
    "/quiz",
    "/register"
  ]
