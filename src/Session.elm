module Session exposing (Session(..), navKey)

import Browser.Navigation as Nav
import Identity exposing (Identity)


type Session
    = LoggedIn Identity Nav.Key
    | Guest Nav.Key


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn _ key ->
            key

        Guest key ->
            key


-- identity : Session -> Maybe Identity
-- identity session =
--     case session of
--         LoggedIn val _ ->
--             Just val

--         Guest _ ->
--             Nothing
