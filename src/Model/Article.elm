module Model.Article exposing (Article, listDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Model.Author as Author exposing (Author)
import Time


type alias Article =
    { title : String
    , description : String
    , createdAt : Time.Posix
    , favoritesCount : Int
    , author : Author
    }


listDecoder : Decoder (List Article)
listDecoder =
    field "articles" (list decoder)


decoder : Decoder Article
decoder =
    Decode.succeed Article
        |> required "title" string
        |> required "description" string
        |> required "createdAt" datetime
        |> required "favoritesCount" int
        |> required "author" Author.decoder
