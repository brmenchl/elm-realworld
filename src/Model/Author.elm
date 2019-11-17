module Model.Author exposing (Author, authorDecoder)

import Json.Decode as Decode exposing (Decoder, string, nullable)
import Json.Decode.Pipeline exposing (required)
import Asset exposing (Image, imageDecoder)

type alias Author =
  {
    username : String
    , bio : Maybe String
    , image : Image
  }

authorDecoder : Decoder Author
authorDecoder =
  Decode.succeed Author
    |> required "username" string
    |> required "bio" (nullable string)
    |> required "image" imageDecoder