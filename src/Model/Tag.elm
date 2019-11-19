module Model.Tag exposing (Tag, tagListDecoder, tagName)

import Json.Decode as Decode exposing (Decoder, field, list, string)


type Tag
    = Tag String


tagName : Tag -> String
tagName (Tag name) =
    name



-- Decoder


tagListDecoder : Decoder (List Tag)
tagListDecoder =
    field "tags" (list tagDecoder)


tagDecoder : Decoder Tag
tagDecoder =
    Decode.map Tag string
