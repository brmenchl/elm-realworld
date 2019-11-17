module Asset exposing (Image, defaultAvatar, error, imageDecoder, loading, src)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Json.Decode exposing (Decoder, map, string)


type Image
    = Local String
    | Remote String


error : Image
error =
    Local "error.jpg"


loading : Image
loading =
    Local "loading.svg"


defaultAvatar : Image
defaultAvatar =
    Local "smiley-cyrus.jpg"


src : Image -> Attribute msg
src image =
    let
        url =
            case image of
                Local filename ->
                    "/assets/images/" ++ filename

                Remote remoteUrl ->
                    remoteUrl
    in
    Attr.src url


imageDecoder : Decoder Image
imageDecoder =
    map Remote string
