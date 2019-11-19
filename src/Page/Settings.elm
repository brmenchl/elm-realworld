module Page.Settings exposing (Model, Msg, init, toSession, update, view)

import Asset exposing (imageUrl)
import Html exposing (Html, button, div, fieldset, form, h1, hr, input, text, textarea)
import Html.Attributes exposing (class, placeholder, rows, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Session exposing (UnknownSession)
import Model.User exposing (User)
import Route


type alias Model =
    { session : UnknownSession
    , form : Form
    , problems : List Problem
    }


type Problem
    = ClientError String


type alias Form =
    { imageUrl : String
    , username : String
    , bio : String
    , email : String
    , password : String
    }


formFromUser : Maybe User -> Form
formFromUser maybeUser =
    case maybeUser of
        Just user ->
            { imageUrl = imageUrl user.image
            , username = user.username
            , bio = Maybe.withDefault "" user.bio
            , email = user.email
            , password = ""
            }

        Nothing ->
            { imageUrl = ""
            , username = ""
            , bio = ""
            , email = ""
            , password = ""
            }


init : UnknownSession -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , form = formFromUser session.user
      , problems = []
      }
    , Cmd.none
    )


type Msg
    = ChangedImageUrl String
    | ChangedUsername String
    | ChangedBio String
    | ChangedEmail String
    | ChangedPassword String
    | LogoutClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedImageUrl imageUrl ->
            updateForm (\form -> { form | imageUrl = imageUrl }) model

        ChangedUsername username ->
            updateForm (\form -> { form | username = username }) model

        ChangedBio bio ->
            updateForm (\form -> { form | bio = bio }) model

        ChangedEmail email ->
            updateForm (\form -> { form | email = email }) model

        ChangedPassword password ->
            updateForm (\form -> { form | password = password }) model

        LogoutClicked ->
            ( { model | session = clearUser model.session }, Route.replaceUrl model.session.key Route.Home )


clearUser : UnknownSession -> UnknownSession
clearUser session =
    { session | user = Nothing }


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ( { model | form = updater model.form }, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Settings"
    , content = content model
    }


content : Model -> Html Msg
content model =
    div [ class "settings-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ] [ text "Your Settings" ]
                    , form []
                        [ fieldset []
                            [ fieldset [ class "form-group" ]
                                [ input [ class "form-control", type_ "text", placeholder "URL of profile picture", value model.form.imageUrl, onInput ChangedImageUrl ] []
                                ]
                            , fieldset [ class "form-group" ]
                                [ input [ class "form-control form-control-lg", type_ "text", placeholder "Your Name", value model.form.username, onInput ChangedUsername ] []
                                ]
                            , fieldset [ class "form-group" ]
                                [ textarea [ class "form-control form-control-lg", rows 8, placeholder "Short bio about you", value model.form.bio, onInput ChangedBio ] []
                                ]
                            , fieldset [ class "form-group" ]
                                [ input [ class "form-control form-control-lg", type_ "text", placeholder "Email", value model.form.email, onInput ChangedEmail ] []
                                ]
                            , fieldset [ class "form-group" ]
                                [ input [ class "form-control form-control-lg", type_ "password", placeholder "New Password", value model.form.password, onInput ChangedPassword ] []
                                ]
                            , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                                [ text "Update Settings" ]
                            ]
                        ]
                    , hr [] []
                    , button [ onClick LogoutClicked, class "btn btn-outline-danger" ]
                        [ text "Or click here to logout." ]
                    ]
                ]
            ]
        ]



-- Session


toSession : Model -> UnknownSession
toSession model =
    model.session
