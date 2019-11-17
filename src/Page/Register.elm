module Page.Register exposing (Model, Msg, init, toSession, update, view)

import Api exposing (RequestResponse, decodeErrors)
import Api.Register exposing (registerRequest, toRegisterCredentials)
import Form exposing (Validator, all, atLeastMinimum, atMostMaximum, firstOf, fromValid, required, validate)
import Html exposing (Html, a, button, div, fieldset, form, h1, input, li, p, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Html.Extra exposing (nothing)
import Model.User exposing (User)
import Route exposing (replaceUrl, toHref)
import Session exposing (Session)


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
    , username : String
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , problems = []
      , form = Form "" "" ""
      }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = SubmittedForm
    | ChangedUsername String
    | ChangedEmail String
    | ChangedPassword String
    | CompletedRegister (RequestResponse User)


formValidator : Validator String Form
formValidator =
    all
        [ required .email "Email"
        , required .password "Password"
        , firstOf
            [ required .username "Username"
            , atLeastMinimum .username "Username" 2
            , atMostMaximum .username "Username" 20
            ]
        ]


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
                    , registerRequest CompletedRegister (toRegisterCredentials form.username form.email form.password)
                    )

                Err problems ->
                    ( { model | problems = List.map ClientError problems }, Cmd.none )

        CompletedRegister (Err error) ->
            let
                serverProblems =
                    decodeErrors error
            in
            ( { model | problems = List.map ServerError serverProblems }, Cmd.none )

        CompletedRegister (Ok ( _, user )) ->
            ( { model | session = Session.updateUser model.session (Just user) }
            , replaceUrl (Session.navKey model.session) Route.Home
            )

        ChangedUsername username ->
            updateForm (\form -> { form | username = username }) model

        ChangedEmail email ->
            updateForm (\form -> { form | email = email }) model

        ChangedPassword password ->
            updateForm (\form -> { form | password = password }) model


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ( { model | form = updater model.form }, Cmd.none )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Sign Up"
    , content = content model
    }


content : Model -> Html Msg
content model =
    div [ class "auth-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ]
                        [ text "Sign up" ]
                    , p [ class "text-xs-center" ]
                        [ a [ toHref Route.Login ]
                            [ text "Have an account?" ]
                        ]
                    , viewErrors model.problems
                    , form [ onSubmit SubmittedForm ]
                        [ fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "text", placeholder "Your Name", onInput ChangedUsername, value model.form.username ]
                                []
                            ]
                        , fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "text", placeholder "Email", onInput ChangedEmail, value model.form.email ]
                                []
                            ]
                        , fieldset [ class "form-group" ]
                            [ input [ class "form-control form-control-lg", type_ "password", placeholder "Password", onInput ChangedPassword, value model.form.password ]
                                []
                            ]
                        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                            [ text "Sign up" ]
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
