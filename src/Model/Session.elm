module Model.Session exposing (Session)

import Browser.Navigation as Nav
import Model.User exposing (User)


type alias Session =
    { key : Nav.Key
    , user : Maybe User
    }
