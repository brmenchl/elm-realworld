module Layout.Header exposing (viewHeader)

import Html exposing (Attribute, Html, a, div, i, li, nav, text, ul)
import Html.Attributes exposing (class, href)
import Route exposing (Route(..))
import View.Icon exposing (Icon, icon)


viewHeader : Html msg
viewHeader =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.toHref Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ]
                [ li [ class "nav-item" ]
                    [ a [ class "nav-link active", Route.toHref Route.Home ]
                        [ text "Home" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", Route.toHref Route.Login ]
                        [ i [ class "ion-compose" ] []
                        , text "New Post"
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", Route.toHref Route.Login ]
                        [ i [ class "ion-gear-a" ] []
                        , text "Settings"
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", Route.toHref Route.Login ]
                        [ text "Sign up" ]
                    ]
                ]
            ]
        ]


navLinkClass : Route -> Route -> Attribute msg
navLinkClass route currentRoute =
    class <|
        String.join
            ""
            [ "nav-link"
            , if currentRoute == route then
                "active"

              else
                ""
            ]


navLink : Route -> Route -> String -> Maybe Icon -> Html msg
navLink currentRoute route linkText maybeIcon =
    li [ class "nav-item" ]
        [ a [ navLinkClass route currentRoute, Route.toHref route ]
            [ icon maybeIcon
            , text linkText
            ]
        ]
