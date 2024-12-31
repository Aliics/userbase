module Userbase.Database.User
  ( selectUsers
  , selectUserWithId
  , createUser
  )
where

import Database.PostgreSQL.Simple (Connection)
import Opaleye
  ( Insert (..)
  , Table
  , limit
  , optionalTableField
  , rReturning
  , requiredTableField
  , runSelect
  , selectTable
  , sqlInt4
  , sqlStrictText
  , table
  , where_
  , (.==)
  )
import Userbase.Database.Internal.RunInsert (runInsertMaybe)
import Userbase.Database.Internal.RunSelect (runSelectMaybe)
import Userbase.Types.User (User, User' (..), UserField, UserFieldWrite, pUser)

userTable :: Table UserFieldWrite UserField
userTable =
  table "users" $
    pUser
      User'
        { userId = optionalTableField "id"
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

createUser :: (?conn :: Connection) => User -> IO (Maybe Int)
createUser User'{
  userEmail = email, userFirstName = firstName, userLastName = lastName} =
  runInsertMaybe
    Insert
      { iTable = userTable
      , iRows =
          [ User'
              { userId = Nothing
              , userEmail = sqlStrictText email
              , userFirstName = sqlStrictText firstName
              , userLastName = sqlStrictText lastName
              }
          ]
      , iReturning = rReturning userId
      , iOnConflict = Nothing
      }
