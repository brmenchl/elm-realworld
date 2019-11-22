module Route exposing (Route(..), fromUrl, replaceUrl, toHref)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Model.Article as Article
import Model.Username as Username exposing (Username)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s, top)


type Route
    = Home
    | Login
    | Register
    | Settings
    | Profile Username
    | Article Article.Slug


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home top
        , Parser.map Login <| s "login"
        , Parser.map Register <| s "register"
        , Parser.map Settings <| s "settings"
        , Parser.map Profile <| Username.urlParser
        , Parser.map Article <| Article.urlParser
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser
        { url
            | path = Maybe.withDefault "" url.fragment
            , fragment = Nothing
        }


path : Route -> String
path route =
    let
        toString : List String -> String
        toString pathParams =
            "#/" ++ String.join "/" pathParams
    in
    toString <|
        case route of
            Home ->
                []

            Login ->
                [ "login" ]

            Register ->
                [ "register" ]

            Settings ->
                [ "settings" ]

            Profile username ->
                [ Username.toHandle username ]

            Article slug ->
                [ Article.slugToString slug ]


toHref : Route -> Attribute msg
toHref route =
    Attr.href (path route)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (path route)
