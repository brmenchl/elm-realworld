module Model.Article exposing (Article, Slug, decoder, slugToString, toString, updateFavorited, urlParser)

import Json.Decode as Decode exposing (Decoder, bool, int, list, map, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Model.Profile as Profile exposing (Profile)
import Model.Tag as Tag exposing (Tag)
import Time
import Url.Parser


type alias Article =
    { title : String
    , description : String
    , createdAt : Time.Posix
    , favoritesCount : Int
    , favorited : Bool
    , author : Profile
    , body : String
    , tags : List Tag
    , slug : Slug
    }


type Slug
    = Slug String


toString : Article -> String
toString article =
    article.title


slugToString : Slug -> String
slugToString (Slug slug) =
    slug


urlParser : Url.Parser.Parser (Slug -> a) a
urlParser =
    Url.Parser.custom "SLUG" (Just << Slug)


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
        |> required "author" Profile.decoder
        |> required "body" string
        |> required "tagList" (list Tag.decoder)
        |> required "slug" (map Slug string)
