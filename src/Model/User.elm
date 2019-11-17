module Model.User exposing (User, decoder)

import Json.Decode as Decode exposing (Decoder, field, nullable, string)
import Json.Decode.Pipeline exposing (required)


type alias User =
    { email : String
    , token : String
    , username : String
    , bio : Maybe String
    , image : Maybe String
    }


decoder : Decoder User
decoder =
    field "user"
        (Decode.succeed User
            |> required "email" string
            |> required "token" string
            |> required "username" string
            |> required "bio" (nullable string)
            |> required "image" (nullable string)
        )
