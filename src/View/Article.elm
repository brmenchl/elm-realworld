module View.Article exposing (viewArticlePreviewList)

import Api exposing (RequestResponse, decodeErrors)
import DateFormat
import Html exposing (Html, a, button, div, h1, i, img, p, span, text)
import Html.Attributes exposing (class, href)
import Image exposing (src)
import Model.Article exposing (Article)
import RemoteData exposing (RemoteData(..))
import Time


viewArticlePreview : Article -> Html msg
viewArticlePreview article =
    div [ class "article-preview" ]
        [ div [ class "article-meta" ]
            [ a [ href "profile.html" ]
                [ img [ src article.author.image ] [] ]
            , div [ class "info" ]
                [ a [ href "", class "author" ]
                    [ text article.author.username ]
                , span [ class "date" ]
                    [ text (formatCreatedAt article.createdAt) ]
                ]
            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                [ i [ class "ion-heart" ] []
                , text (String.fromInt article.favoritesCount)
                ]
            ]
        , a [ href "", class "preview-link" ]
            [ h1 [] [ text article.title ]
            , p [] [ text article.description ]
            , span [] [ text "Read more..." ]
            ]
        ]


viewArticlePreviewList : RequestResponse (List Article) -> List (Html msg)
viewArticlePreviewList response =
    let
        articleWrapper =
            div [ class "article-preview " ]
    in
    List.map (articleWrapper << List.singleton) <|
        case response of
            Success ( _, [] ) ->
                [ text "No articles are here... yet." ]

            Success ( _, articles ) ->
                List.map viewArticlePreview articles

            Failure error ->
                List.map text <| decodeErrors error

            Loading ->
                [ text "Loading articles..." ]

            NotAsked ->
                [ text "No articles are here... yet." ]



-- Formatters


formatCreatedAt : Time.Posix -> String
formatCreatedAt =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        ]
        Time.utc
