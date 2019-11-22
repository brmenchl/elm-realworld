module Page.Login exposing (Model, Msg, init, toSession, update, view)

import Api exposing (WebData)
import Api.User exposing (loginRequest)
import Form exposing (Validator, all, fromValid, required, validate)
import Html exposing (Html, a, button, div, fieldset, form, h1, input, li, p, text, ul)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onInput, onSubmit)
import Html.Extra exposing (nothing)
import Model.Session exposing (Session)
import Model.User exposing (User)
import RemoteData exposing (RemoteData(..))
import Route exposing (replaceUrl, toHref)


type alias Model =
    { session : Session
    , problems : List Problem
    , form : Form
    }


type Problem
    = ClientError String
    | ServerError String


type alias Form =
    { email : String
    , password : String
    }


emptyForm : Form
emptyForm =
    Form "" ""


formValidator : Validator String Form
formValidator =
    all
        [ required .email "Email"
        , required .password "Password"
        ]


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , problems = []
      , form = emptyForm
      }
    , Cmd.none
    )


type Msg
    = SubmittedForm
    | ChangedEmail String
    | ChangedPassword String
    | CompletedLogin (WebData User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate formValidator model.form of
                Ok validForm ->
                    let
                        form =
                            fromValid validForm
                    in
                    ( { model | problems = [] }
                    , loginRequest CompletedLogin form
                    )

                Err problems ->
                    ( { model | problems = List.map ClientError problems }, Cmd.none )

        CompletedLogin (Failure errors) ->
            ( { model | problems = List.map ServerError errors }, Cmd.none )

        CompletedLogin (Success user) ->
            ( { model | session = updateUser model.session (Just user) }
            , replaceUrl model.session.key Route.Home
            )

        CompletedLogin _ ->
            ( model, Cmd.none )

        ChangedEmail email ->
            updateForm (\form -> { form | email = email }) model

        ChangedPassword password ->
            updateForm (\form -> { form | password = password }) model


updateUser : Session -> Maybe User -> Session
updateUser session user =
    { session | user = user }


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ( { model | form = updater model.form }, Cmd.none )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Sign In"
    , content = content model
    }


content : Model -> Html Msg
content model =
    div [ class "auth-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ]
                        [ text "Sign in" ]
                    , p [ class "text-xs-center" ]
                        [ a [ toHref Route.Register ]
                            [ text "Need an account?" ]
                        ]
                    , viewErrors model.problems
                    , form [ onSubmit SubmittedForm ]
                        [ fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "text", placeholder "Email", onInput ChangedEmail ]
                                []
                            ]
                        , fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "password", placeholder "Password", onInput ChangedPassword ]
                                []
                            ]
                        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                            [ text "Sign in" ]
                        ]
                    ]
                ]
            ]
        ]


viewErrors : List Problem -> Html Msg
viewErrors problems =
    if not (List.isEmpty problems) then
        ul [ class "error-messages" ] <|
            List.map viewError problems

    else
        nothing


viewError : Problem -> Html Msg
viewError problem =
    case problem of
        ClientError msg ->
            li [] [ text msg ]

        ServerError msg ->
            li [] [ text msg ]



-- Session


toSession : Model -> Session
toSession =
    .session
