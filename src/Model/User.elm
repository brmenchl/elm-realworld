module Model.User exposing (User, userDecoder)

import Asset exposing (Image, imageDecoder)
import Json.Decode as Decode exposing (Decoder, field, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)
import Model.Credentials exposing (Credentials, credentialsDecoder)


type alias User =
    { email : String
    , credentials : Credentials
    , username : String
    , bio : Maybe String
    , image : Image
    }


userDecoder : Decoder User
userDecoder =
    field "user"
        (Decode.succeed User
            |> required "email" string
            |> required "token" credentialsDecoder
            |> required "username" string
            |> required "bio" (nullable string)
            |> optional "image" imageDecoder Asset.defaultAvatar
        )
