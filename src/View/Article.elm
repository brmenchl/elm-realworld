module View.Article exposing (viewArticlePreviewList)

import Api exposing (RequestResponse, decodeErrors)
import DateFormat
import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Image exposing (src)
import Model.Article exposing (Article)
import Model.Tag as Tag exposing (Tag)
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
        , ul [ class "tag-list" ]
            (List.map
                viewArticleTag
                article.tags
            )
        ]


viewArticleTag : Tag -> Html msg
viewArticleTag tag =
    li [ class "tag-default tag-pill tag-outline" ] [ text (Tag.tagName tag) ]


viewArticlePreviewList : RequestResponse (List Article) -> List (Html msg)
viewArticlePreviewList response =
    case response of
        Success ( _, [] ) ->
            [ div [ class "article-previoew" ] [ text "No articles are here... yet." ] ]

        Success ( _, articles ) ->
            List.map viewArticlePreview articles

        Failure error ->
            List.map text <| decodeErrors error

        Loading ->
            [ div [ class "article-previoew" ] [ text "Loading articles..." ]
            ]

        NotAsked ->
            [ div [ class "article-previoew" ] [ text "No articles are here... yet." ] ]



-- Formatters


formatCreatedAt : Time.Posix -> String
formatCreatedAt =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        ]
        Time.utc
