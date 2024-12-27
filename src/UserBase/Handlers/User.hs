module UserBase.Handlers.User (userHandlers) where

import Database.PostgreSQL.Simple (Connection)
import Network.HTTP.Types (status200)
import Web.Scotty (ScottyM, get, status)

userHandlers :: (?conn :: Connection) => ScottyM ()
userHandlers = do
  get "/users/" $ do
    status status200
