module Model.User exposing (User, decoder)

import Image exposing (Image, defaultAvatar)
import Json.Decode as Decode exposing (Decoder, field, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)
import Model.Credentials as Credentials exposing (Credentials)
import Model.Username as Username exposing (Username)


type alias User =
    { email : String
    , credentials : Credentials
    , username : Username
    , bio : Maybe String
    , image : Image
    }


decoder : Decoder User
decoder =
    field "user"
        (Decode.succeed User
            |> required "email" string
            |> required "token" Credentials.decoder
            |> required "username" Username.decoder
            |> required "bio" (nullable string)
            |> optional "image" Image.decoder defaultAvatar
        )
