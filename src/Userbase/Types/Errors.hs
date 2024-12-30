{-# LANGUAGE DeriveAnyClass #-}
module Userbase.Types.Errors (HandleError (..)) where
import Control.Exception (Exception)

data HandleError
  = NotFound deriving (Show, Exception)
