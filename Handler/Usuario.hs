{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE ViewPatterns         #-}

module Handler.Usuario where

import Foundation
import Yesod
import Data.Text
import Text.Lucius
import Text.Julius
import Handler.Widget
import Database.Persist.Postgresql

formUsuario :: Form Usuario
formUsuario = renderDivs $ Usuario
    <$> areq textField "Nome: " Nothing 
    <*> areq intField  "Idade: " Nothing
    <*> areq textField "Login: " Nothing  
    <*> areq passwordField "Senha: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (widget, enctype) <- generateFormPost formUsuario
    defaultLayout $ do 
        widgetForm UsuarioR enctype widget "Usuario"
        toWidget $(luciusFile "templates/lucius/formuser.lucius")
        
postUsuarioR :: Handler Html
postUsuarioR = do
    ((result, _), _) <- runFormPost formUsuario
    case result of 
        FormSuccess usuario -> do (runDB $ insert usuario) >>= \pid -> redirect (PerfilR pid) 
        _ -> redirect FailR
        

getListaUsuarioR :: Handler Html
getListaUsuarioR = do
    usuarios <- runDB $ selectList [] [Asc UsuarioNome]
    defaultLayout $ do
        setTitle "PorTIfolio | Usuários cadastrados"
    
        toWidgetHead [hamlet|
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
        |]
    
        addStylesheet $ StaticR css_navbar_css
        addStylesheet $ StaticR css_blogspost_css
        remoteWidget
        $(whamletFile "templates/hamlet/listaUsuario.hamlet")

formLogin :: Form (Text, Text)
formLogin = renderDivs $ (,) 
    <$> areq textField "Login:  " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getLoginR :: Handler Html
getLoginR = do
    deleteSession "_ID"
    (widget, enctype) <- generateFormPost formLogin
    defaultLayout $ do
        remoteWidget
        $(whamletFile "templates/hamlet/login.hamlet")
        toWidget $(luciusFile "templates/lucius/login.lucius")
        
postLoginR :: Handler Html
postLoginR = do
    ((result, _), _) <- runFormPost formLogin
    case result of
        FormSuccess ("admin","admin") -> setSession "_ID" "admin" >> redirect AdminR
        FormSuccess (login,senha) -> do 
            user <- runDB $ selectFirst [UsuarioLogin ==. login, UsuarioSenha ==. senha] []
            case user of
                Nothing -> redirect LoginR
                Just (Entity pid u) -> setSession "_ID" (pack $ show $ fromSqlKey pid) >> redirect (PerfilR pid)
        _ -> redirect FailR



getAdminR :: Handler Html
getAdminR = do
    defaultLayout $ do
    setTitle "PorTIfolio | Painel do Admin"
    remoteWidget
    $(whamletFile "templates/hamlet/adminpage.hamlet")
    toWidget $(luciusFile "templates/lucius/painelad.lucius")
    

getPerfilR :: UsuarioId -> Handler Html
getPerfilR userid = do
    user <- runDB $ get404 userid
    defaultLayout $ do
        remoteWidget
        $(whamletFile "templates/hamlet/perfil.hamlet") 
        toWidget $(luciusFile "templates/lucius/perfil.lucius")
        
getFailR :: Handler Html
getFailR = defaultLayout $ do
    remoteWidget
    $(whamletFile "templates/hamlet/fail.hamlet")
    toWidget $(luciusFile "templates/lucius/fail.lucius")
    toWidget $(juliusFile "templates/julius/fail.julius")
    


postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_ID"
    defaultLayout[whamlet|
        <h3> Até Logo!
    |]