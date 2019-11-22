module Model.Article exposing (Article, decoder, updateFavorited)

import Json.Decode as Decode exposing (Decoder, bool, int, list, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Model.Author as Author exposing (Author)
import Model.Slug as Slug exposing (Slug)
import Model.Tag as Tag exposing (Tag)
import Time


type alias Article =
    { title : String
    , description : String
    , createdAt : Time.Posix
    , favoritesCount : Int
    , favorited : Bool
    , author : Author
    , body : String
    , tags : List Tag
    , slug : Slug
    }


updateFavorited : Bool -> Article -> Article
updateFavorited newFavorited article =
    { article | favorited = newFavorited }


decoder : Decoder Article
decoder =
    Decode.succeed Article
        |> required "title" string
        |> required "description" string
        |> required "createdAt" datetime
        |> required "favoritesCount" int
        |> required "favorited" bool
        |> required "author" Author.decoder
        |> required "body" string
        |> required "tagList" (list Tag.decoder)
        |> required "slug" Slug.decoder
