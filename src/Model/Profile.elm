module Model.Profile exposing (Profile, decoder)

import Image exposing (Image, defaultAvatar)
import Json.Decode as Decode exposing (Decoder, bool, field, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)
import Model.Username as Username exposing (Username)


type alias Profile =
    { username : Username
    , bio : Maybe String
    , image : Image
    , following : Bool
    }


decoder : Decoder Profile
decoder =
    field "profile"
        (Decode.succeed Profile
            |> required "username" Username.decoder
            |> required "bio" (nullable string)
            |> optional "image" Image.decoder defaultAvatar
            |> required "following" bool
        )
