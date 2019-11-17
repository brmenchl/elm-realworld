module Model.Credentials exposing (Credentials(..), credentialsDecoder, toTokenString)

import Json.Decode exposing (Decoder, map, string)


type Credentials
    = Credentials String


toTokenString : Credentials -> String
toTokenString (Credentials tokenString) =
    tokenString


credentialsDecoder : Decoder Credentials
credentialsDecoder =
    map Credentials string
