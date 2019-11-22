module Api.Login exposing (LoginCredentials, loginRequest, toLoginCredentials)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Http
import Json.Encode exposing (Value, object, string)
import Model.User as User exposing (User)


type LoginCredentials
    = LoginCredentials String String


toLoginCredentials : String -> String -> LoginCredentials
toLoginCredentials email password =
    LoginCredentials email password


loginRequest : (WebData User -> msg) -> LoginCredentials -> Cmd msg
loginRequest toMsg loginCredentials =
    Api.post
        { endpoint = Endpoint.login
        , credentials = Nothing
        , body = Just <| Http.jsonBody (loginCredentialsEncoder loginCredentials)
        , toMsg = toMsg
        , decoder = User.decoder
        }


loginCredentialsEncoder : LoginCredentials -> Value
loginCredentialsEncoder (LoginCredentials email password) =
    object
        [ ( "user"
          , object
                [ ( "email", string email )
                , ( "password", string password )
                ]
          )
        ]
