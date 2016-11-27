{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Application where

import Foundation
import Yesod.Core
import Text.Julius

import Home
import Handler.Usuario
import Handler.Portifolio
import Handler.Evento
import Handler.Noticia
import Handler.Download
import Handler.Widget


mkYesodDispatch "App" resourcesApp

getHomeR :: Handler Html
getHomeR = do
    sess <- lookupSession "_ID"
    defaultLayout $ do
    setTitle "porTIfolio | Bem-vindo"
    toWidgetHead [hamlet|
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
    |]
        
    addStylesheet $ StaticR css_style_css
    addStylesheet $ StaticR css_navbar_css
    addStylesheet $ StaticR css_footer_css
       
    addScript $ StaticR js_main_js
    
    remoteWidget
    [whamlet|
        <div .example3>
            <div .nav .navbar .navbar-inverse .navbar-fixed-top>
                <div .container>
                    <div .navbar-header>
                        <button type="button" .navbar-toggle .collapsed data-toggle="collapse" data-target="#navbar3">
                            <span .sr-only>Toggle navigation
                            <span .icon-bar>
                            <span .icon-bar>
                            <span .icon-bar>
                        <a .navbar-brand href=@{HomeR}><img src=@{StaticR img_logomenu_png} alt="Página Inicial"></a>
                    <div #navbar3 .navbar-collapse .collapse>
                        <ul .nav .navbar-nav .navbar-right>
                            <li .active><a href=@{HomeR}>Home</a>
                            <li .dropdown>
                                <a .dropdown-toggle data-toggle="dropdown" href="#">Portifolios<b .caret></b></a>
                                <ul .dropdown-menu>
                                    <li><a href=@{PortifolioR}>Cadastro</a> 
                                    <li><a href=@{ListaPortifolioR}>Acervo</a>
                            <li><a href=@{ListaEventoR}>Eventos</a> 
                            <li><a href=@{ListaNoticiaR}>Notícias</a>
                            <li><a href=@{ListaDownloadR}>Downloads</a>
                            $maybe _ <- sess
                                <li> 
                                    <form action=@{LogoutR} method=post>
                                        <input type="submit" value="Logout">
                            $nothing
                                <li> <a href=@{LoginR}>Login</a>
    |]
    toWidget $(juliusFile "templates/julius/slider.julius")
    
    [whamlet|
        <section .section>
            <div .container>
                
        <section .parallax1>
                <div .parallax-inner>
                    <center><img src=@{StaticR img_sobremsg_png}></center>
                     <div .inneri><center><a href="#parallax3" .btn .btn-mod .btn-border-w .btn-round .btn-large>EXPLORE</a> <a href=@{UsuarioR} .btn .btn-mod .btn-border-w .btn-round .btn-large>CADASTRE-SE</a></center>
         
                    
    |]
        
    $(whamletFile "templates/hamlet/footer.hamlet")