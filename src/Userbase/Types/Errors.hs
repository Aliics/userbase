{-# LANGUAGE DeriveAnyClass #-}

module Userbase.Types.Errors (HandleError (..)) where

import Control.Exception (Exception)
import Data.Text.Lazy qualified as T

data HandleError
  = NotFound
  | InternalServerError T.Text
  deriving (Show, Exception)
