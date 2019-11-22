module Model.Author exposing (Author, decoder)

import Image exposing (Image)
import Json.Decode as Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline exposing (required)
import Model.Username as Username exposing (Username)


type alias Author =
    { username : Username
    , bio : Maybe String
    , image : Image
    }


decoder : Decoder Author
decoder =
    Decode.succeed Author
        |> required "username" Username.decoder
        |> required "bio" (nullable string)
        |> required "image" Image.decoder
