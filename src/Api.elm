module Api exposing (decodeErrors)

import Http.Detailed
import Json.Decode exposing (Decoder, decodeString, field, keyValuePairs, list, map, string)


decodeErrors : Http.Detailed.Error String -> List String
decodeErrors error =
    case error of
        Http.Detailed.BadStatus _ body ->
            case decodeString errorDecoder body of
                Ok errors ->
                    errors

                _ ->
                    [ "Server Error" ]

        _ ->
            [ "Server Error" ]


errorDecoder : Decoder (List String)
errorDecoder =
    field "errors" (keyValuePairs (list string))
        |> map (List.concatMap errorFromPair)


errorFromPair : ( String, List String ) -> List String
errorFromPair ( key, errors ) =
    List.map (\error -> key ++ " " ++ error) errors
