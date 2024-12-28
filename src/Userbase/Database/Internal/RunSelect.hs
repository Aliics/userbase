module Userbase.Database.Internal.RunSelect (runSelectMaybe) where

import Data.Functor ((<&>))
import Data.Profunctor.Product.Default (Default)
import Database.PostgreSQL.Simple (Connection)
import Opaleye (FromFields, Select, runSelect)

runSelectMaybe ::
  (Default FromFields fields haskells) =>
  Connection ->
  Select fields ->
  IO (Maybe haskells)
runSelectMaybe conn select = runSelect conn select <&> (pure . head)
