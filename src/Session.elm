module Session exposing (Session(..), navKey, updateUser)

import Browser.Navigation as Nav
import Model.User exposing (User)


type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key


user : Session -> Maybe User
user session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


updateUser : Session -> Maybe User -> Session
updateUser session maybeUser =
    let
        key =
            navKey session
    in
    case maybeUser of
        Just val ->
            LoggedIn key val

        Nothing ->
            Guest key
