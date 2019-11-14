module Page exposing (view)

import Browser exposing (Document)
import Html exposing (Html)
import Layout.Footer exposing (viewFooter)
import Layout.Header exposing (viewHeader)


view : { title : String, content : Html msg } -> Document msg
view { title, content } =
    { title = title ++ " — Conduit"
    , body = viewLayout content
    }


viewLayout : Html msg -> List (Html msg)
viewLayout content =
    viewHeader :: content :: [ viewFooter ]
