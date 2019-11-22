module View.PaginatedList exposing (ListResponseDetails, PageDetails, getPageDetails, viewPageLinks)

import Api exposing (WebData)
import Html exposing (Attribute, Html, a, li, nav, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.Extra as Html
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..))


type alias PageDetails =
    { currentPage : Int, totalPages : Int }


type alias ListResponseDetails =
    { limit : Int, offset : Int, totalItems : Int }


getPageDetails : ListResponseDetails -> PageDetails
getPageDetails { limit, offset, totalItems } =
    let
        totalPages =
            round <| toFloat totalItems / toFloat limit

        currentPage =
            offset // limit + 1
    in
    { totalPages = totalPages
    , currentPage = currentPage
    }



-- View


viewPageLinks : (Int -> msg) -> WebData PageDetails -> Html msg
viewPageLinks clickedMsg pageDetails =
    case pageDetails of
        Success { currentPage, totalPages } ->
            nav []
                [ ul [ class "pagination" ] <|
                    List.map (viewPageLink clickedMsg currentPage) (List.range 1 totalPages)
                ]

        _ ->
            Html.nothing


viewPageLink : (Int -> msg) -> Int -> Int -> Html msg
viewPageLink clickedMsg currentPage page =
    li [ classList [ ( "page-item", True ), ( "active", page == currentPage ) ] ]
        [ a [ class "page-link", onClick (clickedMsg page), href "" ] [ text <| String.fromInt page ] ]
