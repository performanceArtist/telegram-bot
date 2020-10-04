module Bot.Model.BotState where

import Data.HashMap.Strict (HashMap)

import Bot.Parser.Model (Command())

type ChatID = Int

type PendingCommand = Command

type BotState = HashMap ChatID PendingCommand
