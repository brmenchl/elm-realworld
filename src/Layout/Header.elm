module Layout.Header exposing (viewHeader)

import Html exposing (Attribute, Html, a, div, li, nav, text, ul)
import Html.Attributes exposing (class, classList)
import Route exposing (Route(..))
import View.Icon exposing (Icon(..), icon)


viewHeader : Page -> Html msg
viewHeader currentPage =
    let
        foo =
            navLink currentPage
    in
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.toHref Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ]
                [ foo Route.Home "Home" Nothing
                , foo Route.Login "New Post" (Just (Icon "ion-compose"))
                , foo Route.Login "Settings" (Just (Icon "ion-gear-a"))
                , foo Route.Login "Sign up" Nothing
                ]
            ]
        ]


navLinkClass : Route -> Route -> Attribute msg
navLinkClass route currentRoute =
    classList
        [ ( "nav-link", True )
        , ( "active", currentRoute == route )
        ]


navLink : Route -> Route -> String -> Maybe Icon -> Html msg
navLink currentRoute route linkText maybeIcon =
    li [ class "nav-item" ]
        [ a [ navLinkClass route currentRoute, Route.toHref route ]
            [ icon maybeIcon
            , text linkText
            ]
        ]
