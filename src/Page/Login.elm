module Page.Login exposing (Model, Msg, init, toSession, update, view)

import Html exposing (Html, a, button, div, fieldset, form, h1, input, li, p, text, ul)
import Html.Attributes exposing (class, href, placeholder, type_)
import Html.Events exposing (onInput, onSubmit)
import Html.Extra exposing (nothing)
import Route exposing (toHref)
import Session exposing (Session)


type alias Model =
    { session : Session
    , problems : List Problem
    , form : Form
    }


type Problem
    = FieldError Field String
    | ServerError String


type alias Form =
    { email : String
    , password : String
    }


type Field
    = Email
    | Password


fields : List Field
fields =
    [ Email
    , Password
    ]


requiredErrorMessage : String
requiredErrorMessage =
    " can't be blank."


validate : Form -> Result (List Problem) Form
validate form =
    case List.concatMap (validateField form) fields of
        [] ->
            Ok form

        problems ->
            Err problems


validateField : Form -> Field -> List Problem
validateField form field =
    List.map (FieldError field) <|
        case field of
            Email ->
                if String.isEmpty form.email then
                    [ "email" ++ requiredErrorMessage ]

                else
                    []

            Password ->
                if String.isEmpty form.password then
                    [ "password" ++ requiredErrorMessage ]

                else
                    []


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , problems = []
      , form = Form "" ""
      }
    , Cmd.none
    )


toSession : Model -> Session
toSession model =
    model.session


type Msg
    = SubmittedForm
    | ChangedEmail String
    | ChangedPassword String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | problems = [] }, Cmd.none )

                Err problems ->
                    ( { model | problems = problems }, Cmd.none )

        ChangedEmail email ->
            updateForm (\form -> { form | email = email }) model

        ChangedPassword password ->
            updateForm (\form -> { form | password = password }) model


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ( { model | form = updater model.form }, Cmd.none )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Log In"
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
                        [ a [ toHref Route.Login ]
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
        FieldError _ msg ->
            li [] [ text msg ]

        ServerError msg ->
            li [] [ text msg ]
