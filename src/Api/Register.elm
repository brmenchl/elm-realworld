module Api.Register exposing (RegisterCredentials, UpdateUserCredentials, registerRequest, toRegisterCredentials, updateUserRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Http
import Json.Encode exposing (Value, object, string)
import Model.Credentials exposing (Credentials)
import Model.User as User exposing (User)


type RegisterCredentials
    = RegisterCredentials String String String


type alias UpdateUserCredentials =
    { bio : String
    , email : String
    , imageUrl : String
    , password : String
    , username : String
    }


toRegisterCredentials : String -> String -> String -> RegisterCredentials
toRegisterCredentials username email password =
    RegisterCredentials username email password


registerRequest : (WebData User -> msg) -> RegisterCredentials -> Cmd msg
registerRequest toMsg registerCredentials =
    Api.post
        { endpoint = Endpoint.users
        , credentials = Nothing
        , body = Just <| Http.jsonBody (registerCredentialsEncoder registerCredentials)
        , toMsg = toMsg
        , decoder = User.decoder
        }


updateUserRequest : (WebData User -> msg) -> Credentials -> UpdateUserCredentials -> Cmd msg
updateUserRequest toMsg credentials updateUserCredentials =
    Api.put
        { endpoint = Endpoint.user
        , credentials = Just credentials
        , body = Just <| Http.jsonBody (updateUserCredentialsEncoder updateUserCredentials)
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


updateUserCredentialsEncoder : UpdateUserCredentials -> Value
updateUserCredentialsEncoder credentials =
    let
        fieldsToUpdate =
            List.filter (not << String.isEmpty << Tuple.second)
                [ ( "username", credentials.username )
                , ( "email", credentials.email )
                , ( "password", credentials.password )
                , ( "bio", credentials.bio )
                , ( "image", credentials.imageUrl )
                , ( "password", credentials.password )
                ]
    in
    object
        [ ( "user"
          , object <|
                List.map (Tuple.mapSecond string) fieldsToUpdate
          )
        ]
