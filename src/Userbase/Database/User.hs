module Userbase.Database.User
  ( selectUsers
  , selectUserWithId
  )
where

import Database.PostgreSQL.Simple (Connection)
import Opaleye
  ( Table
  , limit
  , requiredTableField
  , runSelect
  , selectTable
  , sqlInt4
  , table
  , where_
  , (.==)
  )
import Userbase.Database.Internal.RunSelect (runSelectMaybe)
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

selectUserWithId :: (?conn :: Connection) => Int -> IO (Maybe User)
selectUserWithId uid = runSelectMaybe ?conn $ do
  user <- limit 1 $ selectTable userTable
  where_ $ userId user .== sqlInt4 uid
  pure user
