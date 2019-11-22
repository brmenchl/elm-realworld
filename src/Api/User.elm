module Api.User exposing (LoginCredentials, RegisterCredentials, UpdateUserCredentials, loginRequest, registerRequest, updateUserRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Http
import Json.Decode exposing (field)
import Json.Encode exposing (Value, object, string)
import Model.Credentials exposing (Credentials)
import Model.User as User exposing (User)


type alias LoginCredentials =
    { email : String, password : String }


type alias RegisterCredentials =
    { username : String, email : String, password : String }


type alias UpdateUserCredentials =
    { bio : String
    , email : String
    , imageUrl : String
    , password : String
    , username : String
    }


loginRequest : (WebData User -> msg) -> LoginCredentials -> Cmd msg
loginRequest toMsg loginCredentials =
    Api.post
        { endpoint = Endpoint.login
        , credentials = Nothing
        , body = Just <| Http.jsonBody (loginCredentialsEncoder loginCredentials)
        , toMsg = toMsg
        , decoder = field "user" User.decoder
        }


registerRequest : (WebData User -> msg) -> RegisterCredentials -> Cmd msg
registerRequest toMsg registerCredentials =
    Api.post
        { endpoint = Endpoint.users
        , credentials = Nothing
        , body = Just <| Http.jsonBody (registerCredentialsEncoder registerCredentials)
        , toMsg = toMsg
        , decoder = field "user" User.decoder
        }


updateUserRequest : (WebData User -> msg) -> Credentials -> UpdateUserCredentials -> Cmd msg
updateUserRequest toMsg credentials updateUserCredentials =
    Api.put
        { endpoint = Endpoint.user
        , credentials = Just credentials
        , body = Just <| Http.jsonBody (updateUserCredentialsEncoder updateUserCredentials)
        , toMsg = toMsg
        , decoder = field "user" User.decoder
        }



-- Encoders


loginCredentialsEncoder : LoginCredentials -> Value
loginCredentialsEncoder { email, password } =
    object
        [ ( "user"
          , object
                [ ( "email", string email )
                , ( "password", string password )
                ]
          )
        ]


registerCredentialsEncoder : RegisterCredentials -> Value
registerCredentialsEncoder { username, email, password } =
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
