module Page exposing (Page(..), simpleView, view)

import Browser exposing (Document)
import Html exposing (Html, a, div, li, nav, text, ul)
import Html.Attributes exposing (class, classList)
import Layout.Footer exposing (viewFooter)
import Route exposing (Route(..))
import View.Icon exposing (icon)


type Page
    = Other
    | Home
    | Login
    | Register


simpleView : Page -> { title : String, content : Html msg } -> Document msg
simpleView currentPage { title, content } =
    { title = title ++ " — Conduit"
    , body = viewLayout content currentPage
    }


view : Page -> (subMsg -> msg) -> { title : String, content : Html subMsg } -> Document msg
view currentPage toMsg config =
    let
        basePage =
            simpleView currentPage config
    in
    { title = basePage.title
    , body = List.map (Html.map toMsg) basePage.body
    }


viewLayout : Html msg -> Page -> List (Html msg)
viewLayout content currentPage =
    [ viewHeader currentPage
    , content
    , viewFooter
    ]


viewHeader : Page -> Html msg
viewHeader currentPage =
    let
        linkTo =
            navLink currentPage
    in
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.toHref Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ]
                [ linkTo Route.Home [ text "Home" ]
                , linkTo Route.Login
                    [ icon "ion-compose"
                    , text "New Post"
                    ]
                , linkTo Route.Login
                    [ icon "ion-gear-a"
                    , text "Settings"
                    ]
                , linkTo Route.Login [ text "Sign up" ]
                ]
            ]
        ]


navLink : Page -> Route -> List (Html msg) -> Html msg
navLink currentPage route content =
    li [ classList [ ( "nav-item", True ), ( "active", isActive currentPage route ) ] ]
        [ a [ class "nav-link", Route.toHref route ] content ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        _ ->
            False
