{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UndecidableInstances #-}

module Userbase.Types.User
  ( User' (..)
  , User
  , UserFieldWrite
  , UserField
  , CreateUser (..)
  , pUser
  , defaultUser
  ) where

import Control.Applicative (empty)
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), object, (.:), (.=))
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

defaultUser :: User
defaultUser = User'{userId = 0, userEmail = "", userFirstName = "", userLastName = ""}

instance ToJSON User where
  toJSON u =
    object
      [ "id" .= userId u
      , "email" .= userEmail u
      , "firstName" .= userFirstName u
      , "lastName" .= userLastName u
      ]

type UserFieldWrite =
  User' (Maybe (Field SqlInt4)) (Field SqlText) (Field SqlText) (Field SqlText)
type UserField =
  User' (Field SqlInt4) (Field SqlText) (Field SqlText) (Field SqlText)

$(makeAdaptorAndInstanceInferrable "pUser" ''User')

data CreateUser = CreateUser
  { createUserEmail :: T.Text
  , createUserFirstName :: T.Text
  , createUserLastName :: T.Text
  }

instance ToJSON CreateUser where
  toJSON u =
    object
      [ "email" .= createUserEmail u
      , "firstName" .= createUserFirstName u
      , "lastName" .= createUserLastName u
      ]

instance FromJSON CreateUser where
  parseJSON (Object v) =
    CreateUser
      <$> v .: "email"
      <*> v .: "firstName"
      <*> v .: "lastName"
  parseJSON _ = empty
