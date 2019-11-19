module Api.Register exposing (RegisterCredentials, registerRequest, toRegisterCredentials)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Http
import Json.Encode exposing (Value, object, string)
import Model.User as User exposing (User)


type RegisterCredentials
    = RegisterCredentials String String String


toRegisterCredentials : String -> String -> String -> RegisterCredentials
toRegisterCredentials username email password =
    RegisterCredentials username email password


registerRequest : (RequestResponse User -> msg) -> RegisterCredentials -> Cmd msg
registerRequest toMsg registerCredentials =
    Api.post
        { endpoint = Endpoint.users
        , credentials = Nothing
        , body = Http.jsonBody (registerCredentialsEncoder registerCredentials)
        , toMsg = toMsg
        , decoder = User.decoder
        }


registerCredentialsEncoder : RegisterCredentials -> Value
registerCredentialsEncoder (RegisterCredentials username email password) =
    object
        [ ( "user"
          , object
                [ ( "username", string username )
                , ( "email", string email )
                , ( "password", string password )
                ]
          )
        ]
