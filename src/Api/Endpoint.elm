module Api.Endpoint exposing (Endpoint, articles, login, toUrl, userList)

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


userList : Endpoint
userList =
    fromUrlPieces [ "users" ] []


articles : List QueryParameter -> Endpoint
articles params =
    fromUrlPieces [ "articles" ] params
