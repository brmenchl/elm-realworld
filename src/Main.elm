module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Page
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- Model


type Model
    = NotFound Session
    | Home Session


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    updateRoute (Route.fromUrl url) (NotFound <| Session.Guest navKey)


toSession : Model -> Session
toSession model =
    case model of
        NotFound session ->
            session

        Home session ->
            session



-- VIEW


view : Model -> Browser.Document msg
view model =
    case model of
        NotFound _ ->
            Page.view NotFound.view

        Home _ ->
            Page.view Home.view



-- UPDATE


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url


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
            ( Home session, Cmd.none )

        Just _ ->
            ( NotFound session, Cmd.none )

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
