module Userbase.Handlers.User (userHandlers) where

import Database.PostgreSQL.Simple (Connection)
import Userbase.Database.User (selectUserWithId, selectUsers)
import Web.Scotty
  ( ScottyM
  , get
  , json
  , liftIO
  , pathParam
  )

userHandlers :: (?conn :: Connection) => ScottyM ()
userHandlers = do
  get "/users/" $ do
    users <- liftIO selectUsers
    json users

  get "/users/:id" $ do
    uid <- pathParam "id"
    user <- liftIO . selectUserWithId $ read uid
    json user
