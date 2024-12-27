module UserBase (server) where

import Database.PostgreSQL.Simple (Connection)
import Network.Wai.Middleware.RequestLogger (logStdout)
import UserBase.Handlers.User (userHandlers)
import Web.Scotty (ScottyM, middleware)

server :: Connection -> ScottyM ()
server conn = do
  let ?conn = conn

  middleware logStdout

  userHandlers
