module Api exposing (RequestResponse, decodeErrors, get, post, put)

import Api.Endpoint exposing (Endpoint, toUrl)
import Http
import Http.Detailed
import Json.Decode exposing (Decoder, decodeString, field, keyValuePairs, list, map, string)
import Model.Credentials exposing (Credentials, toTokenString)
import RemoteData


type alias RequestResponse body =
    RemoteData.RemoteData (Http.Detailed.Error String) ( Http.Metadata, body )



-- Header Builders


credentialsHeader : Credentials -> Http.Header
credentialsHeader credentials =
    Http.header "authorization" ("Token " ++ toTokenString credentials)



-- Request Builders


type alias RequestOptions msg model =
    { endpoint : Endpoint
    , credentials : Maybe Credentials
    , toMsg : RequestResponse model -> msg
    , decoder : Decoder model
    }


type alias RequestOptionsWithBody msg model =
    { endpoint : Endpoint
    , credentials : Maybe Credentials
    , toMsg : RequestResponse model -> msg
    , decoder : Decoder model
    , body : Http.Body
    }


get : RequestOptions msg model -> Cmd msg
get { endpoint, credentials, toMsg, decoder } =
    Http.request
        { url = toUrl endpoint
        , method = "GET"
        , timeout = Nothing
        , tracker = Nothing
        , headers =
            case credentials of
                Just creds ->
                    [ credentialsHeader creds ]

                Nothing ->
                    []
        , body = Http.emptyBody
        , expect = Http.Detailed.expectJson (RemoteData.fromResult >> toMsg) decoder
        }


post : RequestOptionsWithBody msg model -> Cmd msg
post { endpoint, credentials, toMsg, decoder, body } =
    Http.request
        { url = toUrl endpoint
        , method = "POST"
        , timeout = Nothing
        , tracker = Nothing
        , body = body
        , headers =
            case credentials of
                Just creds ->
                    [ credentialsHeader creds ]

                Nothing ->
                    []
        , expect = Http.Detailed.expectJson (RemoteData.fromResult >> toMsg) decoder
        }


put : RequestOptionsWithBody msg model -> Cmd msg
put { endpoint, credentials, toMsg, decoder, body } =
    Http.request
        { url = toUrl endpoint
        , method = "PUT"
        , timeout = Nothing
        , tracker = Nothing
        , body = body
        , headers =
            case credentials of
                Just creds ->
                    [ credentialsHeader creds ]

                Nothing ->
                    []
        , expect = Http.Detailed.expectJson (RemoteData.fromResult >> toMsg) decoder
        }



-- Errors


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
