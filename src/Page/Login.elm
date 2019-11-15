module Page.Login exposing (Model, init, toSession, view)

import Html exposing (Html, a, button, div, fieldset, form, h1, input, li, p, text, ul)
import Html.Attributes exposing (class, href, placeholder, type_)
import Session exposing (Session)
import Route exposing (toHref)

type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( Model session, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session


view : { title : String, content : Html msg }
view =
    { title = "Log In"
    , content = content
    }


content : Html msg
content =
    div [ class "auth-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ]
                        [ text "Sign in" ]
                    , p [ class "text-xs-center" ]
                        [ a [ toHref Route.Login ]
                            [ text "Need an account?" ]
                        ]
                    , ul [ class "error-messages" ]
                        [ li []
                            [ text "That email is already taken" ]
                        ]
                    , form []
                        [ fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "text", placeholder "Your Name" ]
                                []
                            ]
                        , fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "text", placeholder "Email" ]
                                []
                            ]
                        , fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "password", placeholder "Password" ]
                                []
                            ]
                        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                            [ text "Sign up" ]
                        ]
                    ]
                ]
            ]
        ]
