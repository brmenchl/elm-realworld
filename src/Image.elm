module Image exposing (Image, defaultAvatar, error, decoder, imageUrl, loading, src)

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


imageUrl : Image -> String
imageUrl image =
    case image of
        Local _ ->
            ""

        Remote remoteUrl ->
            remoteUrl


src : Image -> Attribute msg
src image =
    Attr.src (imageUrl image)


decoder : Decoder Image
decoder =
    map Remote string
