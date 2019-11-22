module Api exposing (WebData, delete, get, mapSuccess, post, put)

import Api.Endpoint exposing (Endpoint, toUrl)
import Http
import Http.Detailed
import Json.Decode exposing (Decoder, decodeString, field, keyValuePairs, list, map, string)
import Model.Credentials exposing (Credentials, toTokenString)
import RemoteData


type alias RequestResponse body =
    RemoteData.RemoteData (Http.Detailed.Error String) ( Http.Metadata, body )


type alias WebData body =
    RemoteData.RemoteData (List String) body



-- Header Builders


credentialsHeader : Maybe Credentials -> List Http.Header
credentialsHeader maybeCredentials =
    case maybeCredentials of
        Just creds ->
            [ Http.header "authorization" ("Token " ++ toTokenString creds) ]

        Nothing ->
            []


mapSuccess : (a -> b) -> WebData a -> WebData b
mapSuccess mapper webData =
    RemoteData.map mapper webData



-- Request Builders


type alias RequestOptions msg model =
    { endpoint : Endpoint
    , credentials : Maybe Credentials
    , toMsg : WebData model -> msg
    , decoder : Decoder model
    }


type alias RequestOptionsWithBody msg model =
    { endpoint : Endpoint
    , credentials : Maybe Credentials
    , toMsg : WebData model -> msg
    , decoder : Decoder model
    , body : Maybe Http.Body
    }


get : RequestOptions msg model -> Cmd msg
get { endpoint, credentials, toMsg, decoder } =
    Http.request
        { url = toUrl endpoint
        , method = "GET"
        , timeout = Nothing
        , tracker = Nothing
        , headers = credentialsHeader credentials
        , body = Http.emptyBody
        , expect = Http.Detailed.expectJson (mapResponseErrors >> toMsg) decoder
        }


post : RequestOptionsWithBody msg model -> Cmd msg
post { endpoint, credentials, toMsg, decoder, body } =
    Http.request
        { url = toUrl endpoint
        , method = "POST"
        , timeout = Nothing
        , tracker = Nothing
        , body = Maybe.withDefault Http.emptyBody body
        , headers = credentialsHeader credentials
        , expect = Http.Detailed.expectJson (mapResponseErrors >> toMsg) decoder
        }


put : RequestOptionsWithBody msg model -> Cmd msg
put { endpoint, credentials, toMsg, decoder, body } =
    Http.request
        { url = toUrl endpoint
        , method = "PUT"
        , timeout = Nothing
        , tracker = Nothing
        , body = Maybe.withDefault Http.emptyBody body
        , headers = credentialsHeader credentials
        , expect = Http.Detailed.expectJson (mapResponseErrors >> toMsg) decoder
        }


delete : RequestOptions msg model -> Cmd msg
delete { endpoint, credentials, toMsg, decoder } =
    Http.request
        { url = toUrl endpoint
        , method = "DELETE"
        , timeout = Nothing
        , tracker = Nothing
        , body = Http.emptyBody
        , headers = credentialsHeader credentials
        , expect = Http.Detailed.expectJson (mapResponseErrors >> toMsg) decoder
        }



-- Errors


mapResponseErrors : Result (Http.Detailed.Error String) ( a, b ) -> RemoteData.RemoteData (List String) b
mapResponseErrors =
    RemoteData.fromResult >> RemoteData.mapBoth Tuple.second decodeErrors


decodeErrors : Http.Detailed.Error String -> List String
decodeErrors error =
    case error of
        Http.Detailed.BadBody _ _ errorString ->
            let
                log =
                    Debug.log "Error" errorString
            in
            [ "Server Error" ]

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
