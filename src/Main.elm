module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Model.Session exposing (UnknownSession)
import Page exposing (Page(..))
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Register as Register
import Page.Settings as Settings
import Route exposing (Route, replaceUrl)
import Url exposing (Url)



-- Model


type Model
    = NotFound UnknownSession
    | Home Home.Model
    | Login Login.Model
    | Register Register.Model
    | Settings Settings.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    updateRoute (Route.fromUrl url)
        (NotFound { key = key, user = Nothing })


toSession : Model -> UnknownSession
toSession model =
    case model of
        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Login login ->
            Login.toSession login

        Register register ->
            Register.toSession register

        Settings settings ->
            Settings.toSession settings



-- VIEW


view : Model -> Document Msg
view model =
    let
        session =
            toSession model

        viewSimplePage =
            Page.simpleView session.user

        viewPage =
            Page.view session.user
    in
    case model of
        NotFound _ ->
            viewSimplePage Page.Other NotFound.view

        Home home ->
            viewPage Page.Home HomeMsg (Home.view home)

        Login login ->
            viewPage Page.Login LoginMsg (Login.view login)

        Register register ->
            viewPage Page.Register RegisterMsg (Register.view register)

        Settings settings ->
            viewPage Page.Settings SettingsMsg (Settings.view settings)



-- UPDATE


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | LoginMsg Login.Msg
    | HomeMsg Home.Msg
    | RegisterMsg Register.Msg
    | SettingsMsg Settings.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        -- This is from the example, apparently it makes the css work
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl (.key <| toSession model) (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            updateRoute (Route.fromUrl url) model

        ( HomeMsg submsg, Home home ) ->
            subUpdate Home HomeMsg <|
                Home.update submsg home

        ( LoginMsg submsg, Login login ) ->
            subUpdate Login LoginMsg <|
                Login.update submsg login

        ( RegisterMsg submsg, Register register ) ->
            subUpdate Register RegisterMsg <|
                Register.update submsg register

        ( SettingsMsg submsg, Settings settings ) ->
            subUpdate Settings SettingsMsg <|
                Settings.update submsg settings

        ( _, _ ) ->
            ( model, Cmd.none )


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Home ->
            subUpdate Home HomeMsg (Home.init session)

        Just Route.Login ->
            subUpdate Login LoginMsg (Login.init session)

        Just Route.Register ->
            subUpdate Register RegisterMsg (Register.init session)

        Just Route.Settings ->
            case session.user of
                Just user ->
                    subUpdate Settings SettingsMsg (Settings.init { key = session.key, user = user })

                Nothing ->
                    ( model
                    , replaceUrl (.key <| toSession model) Route.Login
                    )


subUpdate : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
subUpdate toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
