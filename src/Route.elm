module Route exposing (Route(..), fromUrl, toHref)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string, top)


type Route
    = Home
    | Login


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home top
        , Parser.map Login <| s "login"
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
    Attr.href (toString route)


toString : Route -> String
toString route =
    "#/" ++ String.join "/" (toPathParams route)


toPathParams : Route -> List String
toPathParams route =
    case route of
        Home ->
            []

        Login ->
            [ "login" ]
