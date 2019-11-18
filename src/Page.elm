module Page exposing (Page(..), simpleView, view)

import Browser exposing (Document)
import Html exposing (Html, a, div, li, nav, text, ul, footer, span)
import Html.Attributes exposing (class, classList, href)
import Model.Session as Session exposing (Session(..))
import Route exposing (Route(..))
import View.Icon exposing (icon)


type Page
    = Other
    | Home
    | Login
    | Register


simpleView : Session -> Page -> { title : String, content : Html msg } -> Document msg
simpleView session currentPage { title, content } =
    { title = title ++ " — Conduit"
    , body = viewLayout content session currentPage
    }


view : Session -> Page -> (subMsg -> msg) -> { title : String, content : Html subMsg } -> Document msg
view session currentPage toMsg config =
    let
        basePage =
            simpleView session currentPage config
    in
    { title = basePage.title
    , body = List.map (Html.map toMsg) basePage.body
    }


viewLayout : Html msg -> Session -> Page -> List (Html msg)
viewLayout content session currentPage =
    [ viewHeader session currentPage
    , content
    , viewFooter
    ]



-- Header


viewHeader : Session -> Page -> Html msg
viewHeader session currentPage =
    let
        linkTo =
            navLink currentPage
    in
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.toHref Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ]
                (case session of
                    Session.LoggedIn _ user ->
                        [ linkTo Route.Home [ text "Home" ]
                        , linkTo Route.Home [ icon "ion-compose", text "New Article" ]
                        , linkTo Route.Home [ icon "ion-gear-a", text "Settings" ]
                        , linkTo Route.Home [ text user.username ]
                        ]

                    Session.Guest _ ->
                        [ linkTo Route.Home [ text "Home" ]
                        , linkTo Route.Login [ text "Sign in" ]
                        , linkTo Route.Register [ text "Sign up" ]
                        ]
                )
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



-- Footer


viewFooter : Html msg
viewFooter =
    footer []
        [ div [ class "container" ]
            [ a [ href "/", class "logo-font" ]
                [ text "conduit" ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from"
                , a [ href "https://thinkster.io" ]
                    [ text "Thinkster" ]
                , text ". Code"
                , text "&"
                , text "design licensed under MIT."
                ]
            ]
        ]
