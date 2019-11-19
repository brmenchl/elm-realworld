module Model.Tag exposing (Tag, listDecoder, tagName)

import Json.Decode as Decode exposing (Decoder, field, list, string)


type Tag
    = Tag String


tagName : Tag -> String
tagName (Tag name) =
    name



-- Decoder


listDecoder : Decoder (List Tag)
listDecoder =
    field "tags" (list decoder)


decoder : Decoder Tag
decoder =
    Decode.map Tag string
