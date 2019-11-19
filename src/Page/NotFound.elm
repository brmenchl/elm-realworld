module Page.NotFound exposing (view)

import Image
import Html exposing (Html, div, h1, img, main_, text)
import Html.Attributes exposing (class, id, src, tabindex)


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Not Found" ]
            , div [ class "row" ]
                [ img [ Image.src Image.error ] [] ]
            ]
    }
