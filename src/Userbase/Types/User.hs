{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UndecidableInstances #-}

module Userbase.Types.User (User' (..), User, UserField, pUser) where

import Data.Aeson (ToJSON (..), object, (.=))
import Data.Profunctor.Product.TH (makeAdaptorAndInstanceInferrable)
import Data.Text qualified as T
import Opaleye (Field, SqlInt4, SqlText)

data User' a b c d = User'
  { userId :: a
  , userEmail :: b
  , userFirstName :: c
  , userLastName :: d 
  }
type User = User' Int T.Text T.Text T.Text
type UserField = User' (Field SqlInt4) (Field SqlText) (Field SqlText) (Field SqlText)

$(makeAdaptorAndInstanceInferrable "pUser" ''User')

instance ToJSON User where
  toJSON u = object
    [ "id"        .= userId u
    , "email"     .= userEmail u
    , "firstName" .= userFirstName u
    , "lastName"  .= userLastName u
    ]
