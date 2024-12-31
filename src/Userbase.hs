module Userbase (server) where

import Database.PostgreSQL.Simple (Connection)
import Network.HTTP.Types (status404, status500)
import Network.Wai.Middleware.RequestLogger (logStdout)
import Userbase.Handlers.User (userHandlers)
import Userbase.Types.Errors (HandleError (..))
import Web.Scotty
  ( ErrorHandler
  , Handler (..)
  , ScottyM
  , defaultHandler
  , middleware
  , status
  , text
  )

server :: Connection -> ScottyM ()
server conn = do
  let ?conn = conn

  middleware logStdout
  defaultHandler handleErrors

  userHandlers

handleErrors :: ErrorHandler IO
handleErrors = Handler handle
 where
  handle NotFound =
    status status404
  handle (InternalServerError e) = do
    status status500
    text e
