{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}

module Foundation where

import Yesod
import Yesod.Static
import Data.Text
import Database.Persist.Postgresql
    (ConnectionPool, SqlBackend, runSqlPool)

staticFiles "static"

data App = App {getStatic :: Static, connPool :: ConnectionPool}

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Usuario
    nome Text
    idade Int
    login Text  
    senha Text
    UniqueLogin login
    deriving Show
    
Portifolio
    nome Text
    formacaoAcademica Text 
    idiomas Text 
    habilidade Text
    experienciaProfissional Text
    linkTrabalho Text 
    contato Text 
    infoAdicional Text
    deriving Show
    
Evento
    nome Text
    descricao Text
    dtEvento Text
    local Text
    infoAdicional Text
    deriving Show

Noticia
    titulo Text
    assunto Text
    deriving Show

Download
    titulo Text
    descricao Text
    linkDownload  Text 
    infoAdicional Text 
    deriving Show
|]

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App where
    authRoute _ = Just LoginR
    
    isAuthorized HomeR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized FailR _ = return Authorized
    isAuthorized UsuarioR _ = return Authorized
    isAuthorized ListaEventoR _ = return Authorized
    isAuthorized ListaNoticiaR _ = return Authorized
    isAuthorized ListaDownloadR _ = return Authorized
    isAuthorized AdminR _ = isAdmin
    isAuthorized EventoR _ = isAdmin
    isAuthorized EventosR _ = isAdmin
    isAuthorized NoticiaR _ = isAdmin
    isAuthorized NoticiasR _ = isAdmin
    isAuthorized DownloadR _ = isAdmin
    isAuthorized DownloadsR _ = isAdmin
    isAuthorized _ _ = isUser
    
isUser :: Handler AuthResult
isUser = do
    mu <- lookupSession "_ID"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just _ -> Authorized

isAdmin :: Handler AuthResult    
isAdmin = do
    mu <- lookupSession "_ID"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "admin" -> Authorized 
        Just _ -> Unauthorized "Voce precisa ser admin para entrar aqui"

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

