{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}

module Handler.Widget where

import Yesod
import Foundation
import Data.Text


remoteWidget :: Widget
remoteWidget = do
    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.css"
    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"


widgetForm :: Route App -> Enctype -> Widget -> Text -> Widget
widgetForm x enctype widget y = $(whamletFile "templates/hamlet/form.hamlet")
