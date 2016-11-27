{-# LANGUAGE OverloadedStrings, QuasiQuotes, 
            TemplateHaskell #-}

import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import Yesod.Static
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql

connStr :: ConnectionString
connStr = "dbname=d5i8p1rcp227c1 host=ec2-54-235-240-76.compute-1.amazonaws.com user=iexqmmnzctvufz password=-RpVybq9PawyVQ7B3pSLl-hY2_ port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
       runSqlPersistMPool (runMigration migrateAll) pool
       static@(Static settings) <- static "static"
       warp 8080 (App static pool)
