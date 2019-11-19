module Page.Profile exposing (Model, Msg, init, toSession, update, view)

import Html exposing (Html, div)
import Model.Session exposing (UnknownSession)
import Model.Username as Username exposing (Username)



--Model


type alias Model =
    { session : UnknownSession
    , username : Username
    }


init : UnknownSession -> Username -> ( Model, Cmd Msg )
init session username =
    ( { session = session
      , username = username
      }
    , Cmd.none
    )



-- Update


type Msg
    = Test


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = Username.toHandle model.username
    , content = content model
    }


content : Model -> Html Msg
content model =
    div [] []



-- Session


toSession : Model -> UnknownSession
toSession =
    .session
