module Model.Slug exposing (Slug, decoder, toString, urlParser)

import Json.Decode exposing (Decoder, map, string)
import Url.Parser


type Slug
    = Slug String


toString : Slug -> String
toString (Slug slug) =
    slug


urlParser : Url.Parser.Parser (Slug -> a) a
urlParser =
    Url.Parser.custom "SLUG" (Just << Slug)


decoder : Decoder Slug
decoder =
    map Slug string
