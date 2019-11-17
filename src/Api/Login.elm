module Api.Login exposing (LoginCredentials, loginRequest, toLoginCredentials)

import Api exposing (RequestResponse)
import Http
import Http.Detailed
import Json.Encode exposing (Value, object, string)
import Model.User exposing (User, decoder)


type LoginCredentials
    = LoginCredentials String String


toLoginCredentials : String -> String -> LoginCredentials
toLoginCredentials email password =
    LoginCredentials email password


loginRequest : (RequestResponse User -> msg) -> LoginCredentials -> Cmd msg
loginRequest toMsg credentials =
    Http.post
        { url = "https://conduit.productionready.io/api/users/login"
        , body = Http.jsonBody (credentialsEncoder credentials)
        , expect = Http.Detailed.expectJson toMsg decoder
        }


credentialsEncoder : LoginCredentials -> Value
credentialsEncoder (LoginCredentials email password) =
    object
        [ ( "user"
          , object
                [ ( "email", string email )
                , ( "password", string password )
                ]
          )
        ]
