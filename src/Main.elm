module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Page exposing (Page(..))
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- Model


type Model
    = NotFound Session
    | Home Home.Model
    | Login Login.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    updateRoute (Route.fromUrl url) (NotFound <| Session.Guest navKey)


toSession : Model -> Session
toSession model =
    case model of
        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Login login ->
            Login.toSession login



-- VIEW


view : Model -> Document Msg
view model =
    case model of
        NotFound _ ->
            Page.simpleView Page.Other NotFound.view

        Home home ->
            Page.view Page.Home HomeMsg (Home.view home)

        Login login ->
            Page.view Page.Login LoginMsg (Login.view login)



-- UPDATE


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | LoginMsg Login.Msg
    | HomeMsg Home.Msg


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
                            ( model, Nav.pushUrl (Session.navKey <| toSession model) (Url.toString url) )

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
