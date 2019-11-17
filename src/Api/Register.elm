module Api.Register exposing (RegisterCredentials, registerRequest, toRegisterCredentials)

import Api exposing (RequestResponse)
import Http
import Http.Detailed
import Json.Encode exposing (Value, object, string)
import Model.User exposing (User, decoder)


type RegisterCredentials
    = RegisterCredentials String String String


toRegisterCredentials : String -> String -> String -> RegisterCredentials
toRegisterCredentials username email password =
    RegisterCredentials username email password


registerRequest : (RequestResponse User -> msg) -> RegisterCredentials -> Cmd msg
registerRequest toMsg credentials =
    Http.post
        { url = "https://conduit.productionready.io/api/users"
        , body = Http.jsonBody (credentialsEncoder credentials)
        , expect = Http.Detailed.expectJson toMsg decoder
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
