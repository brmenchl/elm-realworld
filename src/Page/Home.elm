module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Api exposing (WebData, mapSuccess)
import Api.Article exposing (favoriteArticleRequest, feedArticlesRequest, listArticlesRequest, unfavoriteArticleRequest)
import Api.Tag exposing (listTagsRequest)
import Html exposing (Html, a, div, h1, li, p, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.Extra as Html
import Model.Article as Article exposing (Article)
import Model.Session exposing (Session)
import Model.Slug exposing (Slug)
import Model.Tag exposing (Tag, tagName)
import Model.User exposing (User)
import RemoteData exposing (RemoteData(..))
import Route
import Util
import View.Article exposing (viewArticlePreviewList)


type FeedType
    = Personal
    | Global


type alias Model =
    { session : Session
    , articles : WebData (List Article)
    , tags : WebData (List Tag)
    , feedType : FeedType
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , articles = Loading
      , tags = Loading
      , feedType = defaultFeedType session
      }
    , Cmd.batch
        [ listArticlesRequest CompletedLoadArticles
        , listTagsRequest CompletedLoadTags
        ]
    )


defaultFeedType : Session -> FeedType
defaultFeedType session =
    case session.user of
        Just _ ->
            Personal

        Nothing ->
            Global


type Msg
    = CompletedLoadArticles (WebData (List Article))
    | CompletedLoadTags (WebData (List Tag))
    | ChangedFeedType FeedType
    | ToggledFavoritedArticle Slug
    | CompletedToggleFavoriteArticle (WebData Article)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadArticles articles ->
            ( { model | articles = articles }, Cmd.none )

        CompletedLoadTags tags ->
            ( { model | tags = tags }, Cmd.none )

        ChangedFeedType feedType ->
            case ( feedType, model.session.user ) of
                ( Personal, Just user ) ->
                    ( { model | articles = Loading, feedType = feedType }, feedArticlesRequest CompletedLoadArticles user.credentials )

                ( Global, _ ) ->
                    ( { model | articles = Loading, feedType = feedType }, listArticlesRequest CompletedLoadArticles )

                _ ->
                    ( model, Cmd.none )

        ToggledFavoritedArticle slug ->
            let
                maybeArticle =
                    Util.find (\a -> a.slug == slug) <| RemoteData.withDefault [] model.articles
            in
            case ( model.session.user, maybeArticle ) of
                ( Just user, Just article ) ->
                    let
                        toggleFavoriteArticleRequest request =
                            request CompletedToggleFavoriteArticle user.credentials slug
                    in
                    if article.favorited then
                        ( model, toggleFavoriteArticleRequest unfavoriteArticleRequest )

                    else
                        ( model, toggleFavoriteArticleRequest favoriteArticleRequest )

                _ ->
                    ( model, Route.replaceUrl model.session.key Route.Login )

        CompletedToggleFavoriteArticle (Success article) ->
            ( { model | articles = updateArticle article article.slug model.articles }, Cmd.none )

        CompletedToggleFavoriteArticle _ ->
            ( model, Cmd.none )


updateArticle : Article -> Slug -> WebData (List Article) -> WebData (List Article)
updateArticle newArticle slug articles =
    mapSuccess
        (List.map
            (\article ->
                if article.slug == slug then
                    newArticle

                else
                    article
            )
        )
        articles



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content = content model
    }


content : Model -> Html Msg
content model =
    div [ class "home-page" ]
        [ viewBanner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ] (feedToggle model.session.user model.feedType :: viewArticlePreviewList ToggledFavoritedArticle model.articles)
                , viewPopularTags model.tags
                ]
            ]
        ]


feedToggle : Maybe User -> FeedType -> Html Msg
feedToggle maybeUser currentFeedType =
    let
        feedToggleItem ( title, feedType ) =
            li [ class "nav-item" ]
                [ a [ classList [ ( "nav-link", True ), ( "active", currentFeedType == feedType ) ], href "", onClick (ChangedFeedType feedType) ] [ text title ]
                ]

        userFeedToggle =
            case maybeUser of
                Just _ ->
                    [ ( "Your Feed", Personal ) ]

                Nothing ->
                    []
    in
    div [ class "feed-toggle" ]
        [ ul [ class "nav nav-pills outline-active" ] <|
            List.map feedToggleItem (List.append userFeedToggle [ ( "Global Feed", Global ) ])
        ]


viewPopularTags : WebData (List Tag) -> Html Msg
viewPopularTags tags =
    div [ class "col-md-3" ]
        [ div [ class "sidebar" ]
            [ p []
                [ text "Popular Tags" ]
            , div [ class "tag-list" ]
                (case tags of
                    NotAsked ->
                        [ text "No tags are here... yet." ]

                    Loading ->
                        [ text "Loading tags..." ]

                    Success [] ->
                        [ text "No tags are here... yet." ]

                    Success tagList ->
                        List.map tagPillLink tagList

                    _ ->
                        [ Html.nothing ]
                )
            ]
        ]


tagPillLink : Tag -> Html Msg
tagPillLink tag =
    a [ href "", class "tag-pill tag-default" ] [ text (tagName tag) ]


viewBanner : Html Msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ]
                [ text "conduit" ]
            , p []
                [ text "A place to share your knowledge." ]
            ]
        ]



-- Session


toSession : Model -> Session
toSession =
    .session
