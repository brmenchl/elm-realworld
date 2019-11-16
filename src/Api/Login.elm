module Api.Login exposing (RequestResponse, loginRequest)

import Http
import Http.Detailed
import Model.Credentials exposing (Credentials, encoder)
import Model.User exposing (User, decoder)


type alias RequestResponse =
    Result (Http.Detailed.Error String) ( Http.Metadata, User )


loginRequest : (RequestResponse -> msg) -> Credentials -> Cmd msg
loginRequest toMsg credentials =
    Http.post
        { url = "https://conduit.productionready.io/api/users/login"
        , body = Http.jsonBody (encoder credentials)
        , expect = Http.Detailed.expectJson toMsg decoder
        }
