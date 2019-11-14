module View.Icon exposing (Icon, icon)

import Html exposing (Attribute, Html, i)
import Html.Attributes exposing (class)


type Icon
    = Icon String


iconClass : Maybe Icon -> List (Attribute msg)
iconClass maybeIcon =
    case maybeIcon of
        Just (Icon name) ->
            [ class name ]

        Nothing ->
            []


icon : Maybe Icon -> Html msg
icon maybeIcon =
    i (iconClass maybeIcon) []
