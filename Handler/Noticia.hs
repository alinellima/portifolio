{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE ViewPatterns         #-}

module Handler.Noticia where

import Handler.Widget
import Foundation
import Yesod
import Text.Lucius



formNoticia :: Form Noticia
formNoticia  = renderDivs $ Noticia
    <$> areq textField "Título: " Nothing
    <*> areq textField "Assunto: " Nothing

getNoticiaR :: Handler Html
getNoticiaR = do
    (widget, enctype) <- generateFormPost formNoticia
    defaultLayout $ do
        widgetForm NoticiaR enctype widget "Notícia"
        toWidget $(luciusFile "templates/lucius/formnoticia.lucius")

getListaNoticiaR :: Handler Html
getListaNoticiaR = do
    noticias <- runDB $ selectList [] [Asc NoticiaTitulo]
    defaultLayout $ do
    setTitle "PorTIfolio | Notícias"
    
    toWidgetHead [hamlet|
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
    |]

    addStylesheet $ StaticR css_navbar_css
    addStylesheet $ StaticR css_blogspost_css
    addStylesheet $ StaticR css_footer_css
    
    remoteWidget 
    $(whamletFile "templates/hamlet/listaNoticia.hamlet")
    $(whamletFile "templates/hamlet/footer.hamlet")

postNoticiaR :: Handler Html
postNoticiaR =  do
    ((result, _), _) <- runFormPost formNoticia
    case result of
        FormSuccess noticia -> do
            notid <- runDB $ insert noticia
            defaultLayout [whamlet|
                <h3> #{noticiaTitulo noticia} Inserido com Sucesso!
            |]
        _ -> redirect NoticiaR
        
postDeletaNoticiaR :: NoticiaId -> Handler Html
postDeletaNoticiaR portid = undefined

getNoticiasR  :: Handler Html
getNoticiasR  = undefined
