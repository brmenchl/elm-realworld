module Model.Credentials exposing (Credentials(..), decoder, toTokenString)

import Json.Decode exposing (Decoder, map, string)


type Credentials
    = Credentials String


toTokenString : Credentials -> String
toTokenString (Credentials tokenString) =
    tokenString


decoder : Decoder Credentials
decoder =
    map Credentials string
