module Layout.Footer exposing (viewFooter)

import Html exposing (Html, a, div, footer, span, text)
import Html.Attributes exposing (class, href)


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
