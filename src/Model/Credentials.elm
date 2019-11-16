module Model.Credentials exposing (Credentials, encoder)

import Json.Encode exposing (Value, object, string)


type alias Credentials =
    { email : String
    , password : String
    }


encoder : Credentials -> Value
encoder credentials =
    object
        [ ( "email", string credentials.email )
        , ( "password", string credentials.password )
        ]
