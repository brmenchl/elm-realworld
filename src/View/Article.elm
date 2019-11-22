module View.Article exposing (viewArticlePreviewList)

import Api exposing (WebData)
import DateFormat
import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Image exposing (src)
import Model.Article exposing (Article, Slug)
import Model.Tag as Tag exposing (Tag)
import Model.Username as Username
import RemoteData exposing (RemoteData(..))
import Route
import Time


viewArticlePreview : (Slug -> msg) -> Article -> Html msg
viewArticlePreview favoriteButtonMsg article =
    div [ class "article-preview" ]
        [ div [ class "article-meta" ]
            [ a [ Route.toHref (Route.Profile article.author.username) ]
                [ img [ src article.author.image ] [] ]
            , div [ class "info" ]
                [ a [ Route.toHref (Route.Profile article.author.username), class "author" ]
                    [ text <| Username.toString article.author.username ]
                , span [ class "date" ]
                    [ text (formatCreatedAt article.createdAt) ]
                ]
            , button [ class "btn btn-outline-primary btn-sm pull-xs-right", onClick <| favoriteButtonMsg article.slug ]
                [ i [ class "ion-heart" ] []
                , text (String.fromInt article.favoritesCount)
                ]
            ]
        , a [ Route.toHref (Route.Article article.slug), class "preview-link" ]
            [ h1 [] [ text article.title ]
            , p [] [ text article.description ]
            , span [] [ text "Read more..." ]
            ]
        , ul [ class "tag-list" ]
            (List.map viewArticleTag article.tags)
        ]


viewArticleTag : Tag -> Html msg
viewArticleTag tag =
    li [ class "tag-default tag-pill tag-outline" ] [ text (Tag.tagName tag) ]


viewArticlePreviewList : (Slug -> msg) -> WebData (List Article) -> List (Html msg)
viewArticlePreviewList favoriteButtonMsg response =
    case response of
        Success [] ->
            [ div [ class "article-previoew" ] [ text "No articles are here... yet." ] ]

        Success articles ->
            List.map (viewArticlePreview favoriteButtonMsg) articles

        Failure errors ->
            List.map text errors

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
