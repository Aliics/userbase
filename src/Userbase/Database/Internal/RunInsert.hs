module Userbase.Database.Internal.RunInsert (runInsertMaybe) where

import Data.Maybe (listToMaybe)
import Database.PostgreSQL.Simple (Connection)
import Opaleye (Insert, runInsert)

runInsertMaybe :: (?conn :: Connection) => Insert [Int] -> IO (Maybe Int)
runInsertMaybe ins = listToMaybe <$> runInsert ?conn ins
