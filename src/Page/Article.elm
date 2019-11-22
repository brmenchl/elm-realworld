module Page.Article exposing (Model, Msg, init, toSession, update, view)

import Api exposing (WebData)
import Api.Article exposing (favoriteArticleRequest, loadArticleRequest, unfavoriteArticleRequest)
import DateFormat
import Html exposing (Html, a, button, div, form, h1, h2, hr, i, img, p, span, text, textarea)
import Html.Attributes exposing (class, href, id, placeholder, rows)
import Html.Events exposing (onClick)
import Html.Extra as Html
import Image exposing (defaultAvatar, src)
import Markdown
import Model.Article as Article exposing (Article, Slug)
import Model.Session exposing (Session)
import Model.Username as Username
import RemoteData exposing (RemoteData(..))
import Route
import Time
import Util


type alias Model =
    { session : Session
    , slug : Slug
    , article : WebData Article
    }


init : Session -> Slug -> ( Model, Cmd Msg )
init session slug =
    ( { session = session
      , slug = slug
      , article = Loading
      }
    , loadArticleRequest CompletedLoadArticle slug
    )



-- Update


type Msg
    = CompletedLoadArticle (WebData Article)
    | ToggledFavoritedArticle
    | CompletedToggleFavoriteArticle (WebData Article)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadArticle article ->
            ( { model | article = article }, Cmd.none )

        ToggledFavoritedArticle ->
            case ( model.session.user, model.article ) of
                ( Just user, Success article ) ->
                    let
                        toggleFavoriteArticleRequest request =
                            request CompletedToggleFavoriteArticle user.credentials article.slug
                    in
                    if article.favorited then
                        ( model, toggleFavoriteArticleRequest unfavoriteArticleRequest )

                    else
                        ( model, toggleFavoriteArticleRequest favoriteArticleRequest )

                _ ->
                    ( model, Route.replaceUrl model.session.key Route.Login )

        CompletedToggleFavoriteArticle article ->
            ( { model | article = article }, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = RemoteData.withDefault "Article" <| RemoteData.map Article.toString model.article
    , content = content model
    }


content : Model -> Html Msg
content model =
    case model.article of
        Success article ->
            div [ class "article-page" ]
                [ banner article
                , div [ class "container page" ]
                    [ articleContent article
                    , hr [] []
                    , articleActions article
                    , div [ class "row" ]
                        [ div [ class "col-xs-12 col-md-8 offset-md-2" ]
                            [ commentForm
                            , div [ class "card" ]
                                [ div [ class "card-block" ]
                                    [ p [ class "card-text" ]
                                        [ text "With supporting text below as a natural lead-in to additional content." ]
                                    ]
                                , div [ class "card-footer" ]
                                    [ a [ href "", class "comment-author" ]
                                        [ img [ src defaultAvatar, class "comment-author-img" ] [] ]
                                    , a [ href "", class "comment-author" ] [ text "Jacob Schmidt" ]
                                    , span [ class "date-posted" ] [ text "Dec 29th" ]
                                    , span [ class "mod-options" ]
                                        [ i [ class "ion-edit" ] []
                                        , i [ class "ion-trash-a" ] []
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

        _ ->
            Html.nothing


commentForm : Html Msg
commentForm =
    form [ class "card comment-form" ]
        [ div [ class "card-block" ]
            [ textarea [ class "form-control", placeholder "Write a comment...", rows 3 ] [] ]
        , div [ class "card-footer" ]
            [ img [ src defaultAvatar, class "comment-author-img" ] []
            , button [ class "btn btn-sm btn-primary" ] [ text "Post Comment" ]
            ]
        ]


articleActions : Article -> Html Msg
articleActions article =
    let
        author =
            article.author
    in
    div [ class "article-actions" ]
        [ div [ class "article-meta" ]
            [ a [ Route.toHref <| Route.Profile author.username ]
                [ img [ src author.image ] [] ]
            , div [ class "info" ]
                [ a [ href "", class "author" ] [ text <| Username.toString author.username ]
                , span [ class "date" ] [ text <| formatCreatedAt article.createdAt ]
                ]
            , button [ class "btn btn-sm btn-outline-secondary" ]
                [ i [ class "ion-plus-round" ] []
                , text <| "Follow " ++ Username.toString author.username
                ]
            , button [ class "btn btn-sm btn-outline-primary", onClick ToggledFavoritedArticle ]
                [ i [ class "ion-heart" ] []
                , text "Favorite Post"
                , span [ class "counter" ] [ text ("(" ++ String.fromInt article.favoritesCount ++ ")") ]
                ]
            ]
        ]


articleContent : Article -> Html Msg
articleContent article =
    div [ class "row article-content" ]
        [ div [ class "col-md-12" ] <|
            Markdown.toHtml Nothing article.body
        ]


banner : Article -> Html Msg
banner article =
    let
        author =
            article.author
    in
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [] [ text article.title ]
            , div [ class "article-meta" ]
                [ a [ Route.toHref <| Route.Profile author.username ]
                    [ img [ src author.image ] [] ]
                , div [ class "info" ]
                    [ a [ Route.toHref <| Route.Profile author.username, class "author" ] [ text <| Username.toString author.username ]
                    , span [ class "date" ] [ text <| formatCreatedAt article.createdAt ]
                    ]
                , button [ class "btn btn-sm btn-outline-secondary" ]
                    [ i [ class "ion-plus-round" ] []
                    , text <| "Follow " ++ Username.toString author.username
                    ]
                , button [ class "btn btn-sm btn-outline-primary", onClick ToggledFavoritedArticle ]
                    [ i [ class "ion-heart" ] []
                    , text "Favorite Post"
                    , span [ class "counter" ] [ text ("(" ++ String.fromInt article.favoritesCount ++ ")") ]
                    ]
                ]
            ]
        ]



-- Formatters


formatCreatedAt : Time.Posix -> String
formatCreatedAt =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        ]
        Time.utc



-- Session


toSession : Model -> Session
toSession =
    .session
