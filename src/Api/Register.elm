module Api.Register exposing (RegisterCredentials, registerRequest, toRegisterCredentials)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Http
import Json.Encode exposing (Value, object, string)
import Model.User exposing (User, userDecoder)


type RegisterCredentials
    = RegisterCredentials String String String


toRegisterCredentials : String -> String -> String -> RegisterCredentials
toRegisterCredentials username email password =
    RegisterCredentials username email password


registerRequest : (RequestResponse User -> msg) -> RegisterCredentials -> Cmd msg
registerRequest toMsg credentials =
    Api.post
        { endpoint = Endpoint.userList
        , credentials = Nothing
        , body = Http.jsonBody (credentialsEncoder credentials)
        , toMsg = toMsg
        , decoder = userDecoder
        }


credentialsEncoder : RegisterCredentials -> Value
credentialsEncoder (RegisterCredentials username email password) =
    object
        [ ( "user"
          , object
                [ ( "username", string username )
                , ( "email", string email )
                , ( "password", string password )
                ]
          )
        ]
