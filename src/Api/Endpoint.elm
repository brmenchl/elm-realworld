module Api.Endpoint exposing (Endpoint, articles, feed, login, profile, tags, toUrl, user, users)

import Model.Username as Username exposing (Username)
import Url.Builder exposing (QueryParameter)


type Endpoint
    = Endpoint String


toUrl : Endpoint -> String
toUrl (Endpoint url) =
    url


fromUrlPieces : List String -> List QueryParameter -> Endpoint
fromUrlPieces paths queryParams =
    Url.Builder.crossOrigin "https://conduit.productionready.io/api" paths queryParams |> Endpoint



-- Endpoints


login : Endpoint
login =
    fromUrlPieces [ "users", "login" ] []


users : Endpoint
users =
    fromUrlPieces [ "users" ] []


user : Endpoint
user =
    fromUrlPieces [ "user" ] []


profile : Username -> Endpoint
profile username =
    fromUrlPieces [ "profiles", Username.toString username ] []


articles : List QueryParameter -> Endpoint
articles params =
    fromUrlPieces [ "articles" ] params


feed : List QueryParameter -> Endpoint
feed params =
    fromUrlPieces [ "articles", "feed" ] params


tags : Endpoint
tags =
    fromUrlPieces [ "tags" ] []
