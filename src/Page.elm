module Page exposing (Page(..), simpleView, view)

import Asset exposing (src)
import Browser exposing (Document)
import Html exposing (Html, a, div, footer, img, li, nav, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Model.User exposing (User)
import Route exposing (Route(..))
import View.Icon exposing (icon)


type Page
    = Other
    | Home
    | Login
    | Register
    | Settings


simpleView : Maybe User -> Page -> { title : String, content : Html msg } -> Document msg
simpleView user currentPage { title, content } =
    { title = title ++ " — Conduit"
    , body = viewLayout content user currentPage
    }


view : Maybe User -> Page -> (subMsg -> msg) -> { title : String, content : Html subMsg } -> Document msg
view user currentPage toMsg config =
    let
        basePage =
            simpleView user currentPage config
    in
    { title = basePage.title
    , body = List.map (Html.map toMsg) basePage.body
    }


viewLayout : Html msg -> Maybe User -> Page -> List (Html msg)
viewLayout content user currentPage =
    [ viewHeader user currentPage
    , content
    , viewFooter
    ]



-- Header


viewHeader : Maybe User -> Page -> Html msg
viewHeader maybeUser currentPage =
    let
        linkTo =
            navLink currentPage
    in
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.toHref Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ]
                (case maybeUser of
                    Just user ->
                        [ linkTo Route.Home [ text "Home" ]
                        , linkTo Route.Home [ icon "ion-compose", text "\u{00A0}New Article" ]
                        , linkTo Route.Settings [ icon "ion-gear-a", text "\u{00A0}Settings" ]
                        , linkTo Route.Home [ img [ class "user-pic", src user.image ] [], text user.username ]
                        ]

                    Nothing ->
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

        ( Register, Route.Register ) ->
            True

        ( Settings, Route.Settings ) ->
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
