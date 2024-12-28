module Main where

import Database.PostgreSQL.Simple
import Userbase (server)
import Web.Scotty (scotty)

main :: IO ()
main = do
  conn <- connect ConnectInfo
    { connectUser = "postgres"
    , connectPort     = 5432
    , connectPassword = "password1"
    , connectHost     = "localhost"
    , connectDatabase = "postgres"
    }
  scotty 3000 $ server conn
