{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE ViewPatterns         #-}

module Handler.Evento where

import Handler.Widget
import Foundation
import Yesod
import Text.Lucius


formEvento :: Form Evento
formEvento = renderDivs $ Evento
    <$> areq textField "Nome: " Nothing
    <*> areq textField "Descrição: " Nothing
    <*> areq textField "Data do Evento: " Nothing
    <*> areq textField "Local: " Nothing
    <*> areq textField "Informações Adicionais: " Nothing
    
getEventoR :: Handler Html
getEventoR = do
    (widget, enctype) <- generateFormPost formEvento
    defaultLayout $ do
        widgetForm EventoR enctype widget "Evento"
        toWidget $(luciusFile "templates/lucius/formevento.lucius")

getListaEventoR :: Handler Html
getListaEventoR = do
    eventos <- runDB $ selectList [] [Asc EventoNome]
    defaultLayout $ do
    setTitle "PorTIfolio | Eventos"
        
    toWidgetHead [hamlet|
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
    |]
    
    addStylesheet $ StaticR css_navbar_css
    addStylesheet $ StaticR css_even_css
    addStylesheet $ StaticR css_footer_css
       
    remoteWidget
    $(whamletFile "templates/hamlet/listaEvento.hamlet")
    $(whamletFile "templates/hamlet/footer.hamlet")

postEventoR :: Handler Html
postEventoR = do
    ((result, _), _) <- runFormPost formEvento
    case result of
        FormSuccess evento -> do
            evenid <- runDB $ insert evento
            defaultLayout [whamlet|
                <h3> #{eventoNome evento} Inserido com Sucesso!
            |]
        _ -> redirect EventoR

postDeletaEventoR :: EventoId -> Handler Html
postDeletaEventoR evenid = undefined

getEventosR :: Handler Html
getEventosR = undefined

