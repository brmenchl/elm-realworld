module Model.Username exposing (Username, decoder, encoder, toString, toHandle, urlParser)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Url.Parser


type Username
    = Username String


decoder : Decoder Username
decoder =
    Decode.map Username Decode.string


encoder : Username -> Value
encoder (Username username) =
    Encode.string username


toString : Username -> String
toString (Username username) =
    username


urlParser : Url.Parser.Parser (Username -> a) a
urlParser =
    Url.Parser.custom "USERNAME" <|
        Maybe.andThen
            (\( handle, username ) ->
                if handle == '@' then
                    Just (Username username)

                else
                    Nothing
            )
            << String.uncons


toHandle : Username -> String
toHandle (Username username) =
    String.cons '@' username
