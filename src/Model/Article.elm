module Model.Article exposing (Article, articleListDecoder)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Model.Author exposing (Author, authorDecoder)
import Time


type alias Article =
    { title : String
    , description : String
    , createdAt : Time.Posix
    , favoritesCount : Int
    , author : Author
    }


articleListDecoder : Decoder (List Article)
articleListDecoder =
    field "articles" (list articleDecoder)


articleDecoder : Decoder Article
articleDecoder =
    Decode.succeed Article
        |> required "title" string
        |> required "description" string
        |> required "createdAt" datetime
        |> required "favoritesCount" int
        |> required "author" authorDecoder
