module Userbase.Database.User
  ( selectUsers
  , selectUserWithId
  )
where

import Database.PostgreSQL.Simple (Connection)
import Opaleye
  ( Table
  , requiredTableField
  , runSelect
  , selectTable
  , sqlInt4
  , table
  , where_
  , (.==)
  )
import Userbase.Types.User (User, User' (..), UserField, pUser)

userTable :: Table UserField UserField
userTable =
  table "users" $
    pUser
      User'
        { userId = requiredTableField "id"
        , userEmail = requiredTableField "email"
        , userFirstName = requiredTableField "firstName"
        , userLastName = requiredTableField "lastName"
        }

selectUsers :: (?conn :: Connection) => IO [User]
selectUsers = runSelect ?conn $ selectTable userTable

selectUserWithId :: (?conn :: Connection) => Int -> IO [User]
selectUserWithId uid = runSelect ?conn $ do
  user <- selectTable userTable
  where_ $ userId user .== sqlInt4 uid
  pure user
