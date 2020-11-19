module Bot.Model.BotState where

import           Data.IORef (IORef (..))
import           Data.Set (Set)

import qualified Api.Get.Update

newtype ChatID = ChatID Int deriving (Eq, Show, Ord)

toInt :: ChatID -> Int
toInt (ChatID chatID) = chatID

data BotState = BotState {
  offset        :: Int,
  updates       :: IORef [Api.Get.Update.Update],
  forkedChatIDs :: IORef (Set ChatID)
}
