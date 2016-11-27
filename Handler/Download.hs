{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE ViewPatterns         #-}


module Handler.Download where

import Handler.Widget
import Foundation
import Yesod
import Text.Lucius


formDownload :: Form Download
formDownload = renderDivs $ Download
    <$> areq textField "Título: " Nothing
    <*> areq textField "Descrição: " Nothing
    <*> areq urlField "Link para Download: " Nothing
    <*> areq textField "Informações Adicionais: " Nothing

getDownloadR :: Handler Html
getDownloadR = do
    (widget, enctype) <- generateFormPost formDownload
    defaultLayout $ do
        widgetForm DownloadR enctype widget "Download"
        toWidget $(luciusFile "templates/lucius/formdown.lucius")

getListaDownloadR :: Handler Html
getListaDownloadR = do
    downloads <- runDB $ selectList [] [Asc DownloadTitulo]
    defaultLayout $ do
    setTitle "PorTIfolio | Downloads"
    toWidgetHead [hamlet|
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
    |]
        
    addStylesheet $ StaticR css_navbar_css
    addStylesheet $ StaticR css_blogspost_css
    addStylesheet $ StaticR css_footer_css

    remoteWidget
    $(whamletFile "templates/hamlet/listaDownload.hamlet")
    $(whamletFile "templates/hamlet/footer.hamlet")
    
    
postDownloadR :: Handler Html
postDownloadR = do
    ((result, _), _) <- runFormPost formDownload
    case result of
        FormSuccess download -> do
            downid <- runDB $ insert download
            defaultLayout [whamlet|
                <h3> #{downloadTitulo download} Inserido com Sucesso!
            |]
        _ -> redirect DownloadR



postDeletaDownloadR :: DownloadId -> Handler Html
postDeletaDownloadR downid = undefined

getDownloadsR :: Handler Html
getDownloadsR = undefined

