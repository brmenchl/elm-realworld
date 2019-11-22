module Model.Tag exposing (Tag, decoder, tagName)

import Json.Decode as Decode exposing (Decoder, field, list, string)


type Tag
    = Tag String


tagName : Tag -> String
tagName (Tag name) =
    name



-- Decoder


decoder : Decoder Tag
decoder =
    Decode.map Tag string
