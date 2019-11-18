module Model.Session exposing (AuthenticatedSession, UnknownSession)

import Browser.Navigation as Nav
import Model.User exposing (User)


type alias AuthenticatedSession =
    { key : Nav.Key
    , user : User
    }

type alias UnknownSession =
    { key : Nav.Key
    , user : Maybe User
    }
