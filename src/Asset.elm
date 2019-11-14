module Asset exposing (src)

import Html exposing (Attribute)
import Html.Attributes as Attr


src : String -> Attribute msg
src filename =
    Attr.src
        <| "/assets/images/" ++ filename
