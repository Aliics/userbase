module Userbase.Handlers.User (userHandlers) where

import Database.PostgreSQL.Simple (Connection)
import Userbase.Database.User (selectUsers)
import Web.Scotty (ScottyM, get, json, liftIO)

userHandlers :: (?conn :: Connection) => ScottyM ()
userHandlers = do
  get "/users/" $ do
    users <- liftIO selectUsers
    json users
