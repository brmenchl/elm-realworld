module Route exposing (Route(..), fromUrl, replaceUrl, toHref)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s, top)


type Route
    = Home
    | Login
    | Register
    | Settings


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home top
        , Parser.map Login <| s "login"
        , Parser.map Register <| s "register"
        , Parser.map Settings <| s "settings"
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser
        { url
            | path = Maybe.withDefault "" url.fragment
            , fragment = Nothing
        }


toHref : Route -> Attribute msg
toHref route =
    Attr.href (path route)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (path route)


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
