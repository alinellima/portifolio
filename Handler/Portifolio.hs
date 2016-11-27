{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE ViewPatterns         #-}

module Handler.Portifolio where

import Foundation
import Yesod
--import Database.Persist.Postgresql
--import Data.Text
import Handler.Widget
import Text.Lucius
--import Text.Julius

formPortifolio :: Form Portifolio
formPortifolio = renderDivs $ Portifolio
    <$> areq textField "Nome: " Nothing
    <*> areq textField "Formação Acadêmica: " Nothing
    <*> areq textField "Idiomas: " Nothing
    <*> areq textField "Habilidades e Competências: " Nothing
    <*> areq textField "Experiência Profissional: " Nothing
    <*> areq textField "Seus trabalhos (url): " Nothing
    <*> areq textField "Contato (Redes Sociais)" Nothing
    <*> areq textField "Conte-nos mais sobre você: " Nothing

getPortifolioR :: Handler Html
getPortifolioR = do
    (widget, enctype) <- generateFormPost formPortifolio
    defaultLayout $ do
        widgetForm PortifolioR enctype widget "Portifolio"
        toWidget $(luciusFile "templates/lucius/formdown.lucius")


getListaPortifolioR :: Handler Html
getListaPortifolioR = do
    portifolios <- runDB $ selectList [] [Asc PortifolioNome]
    defaultLayout $ do
    setTitle "PorTIfolio | Portfolios"
    
    toWidgetHead [hamlet|
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
    |]
    
    addStylesheet $ StaticR css_navbar_css
    addStylesheet $ StaticR css_perfil_css
    addStylesheet $ StaticR css_footer_css
    addStylesheet $ StaticR css_blogspost_css
 
    remoteWidget
    $(whamletFile "templates/hamlet/listaPortifolio.hamlet")
    $(whamletFile "templates/hamlet/footer.hamlet")
   

postPortifolioR :: Handler Html
postPortifolioR = do
    ((result, _), _) <- runFormPost formPortifolio
    case result of
        FormSuccess portifolio -> do
            portid <- runDB $ insert portifolio
            defaultLayout [whamlet|
                <h3> Inserido com Sucesso!
            |]
        _ -> redirect PortifolioR
        
        
