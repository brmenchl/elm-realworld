module Model.Author exposing (Author, decoder)

import Image exposing (Image)
import Json.Decode as Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline exposing (required)


type alias Author =
    { username : String
    , bio : Maybe String
    , image : Image
    }


decoder : Decoder Author
decoder =
    Decode.succeed Author
        |> required "username" string
        |> required "bio" (nullable string)
        |> required "image" Image.decoder
