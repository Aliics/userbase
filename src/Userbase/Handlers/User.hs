module Userbase.Handlers.User (userHandlers) where

import Control.Monad (when)
import Data.Maybe (isNothing)
import Database.PostgreSQL.Simple (Connection)
import Userbase.Database.User (createUser, selectUserWithId, selectUsers)
import Userbase.Types.Errors (HandleError (..))
import Userbase.Types.User (CreateUser (..), User' (..), defaultUser)
import Web.Scotty
  ( ScottyM
  , get
  , json
  , jsonData
  , liftIO
  , pathParam
  , post
  , throw
  )

userHandlers :: (?conn :: Connection) => ScottyM ()
userHandlers = do
  get "/users/" $ liftIO selectUsers >>= json

  get "/users/:id" $ do
    uid <- pathParam "id"
    user <- liftIO . selectUserWithId $ read uid
    when (isNothing user) (throw NotFound)
    json user

  post "/users/" $ do
    input :: CreateUser <- jsonData
    uid <-
      liftIO $
        createUser
          defaultUser
            { userEmail = createUserEmail input
            , userFirstName = createUserFirstName input
            , userLastName = createUserLastName input
            }
    when (isNothing uid) (throw $ InternalServerError "Failed to create user")
