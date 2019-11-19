module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Api exposing (RequestResponse, decodeErrors)
import Api.Article exposing (listArticlesRequest)
import Asset exposing (src)
import DateFormat
import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Html.Extra as Html
import Model.Article exposing (Article)
import Model.Session exposing (UnknownSession)
import Model.User exposing (User)
import RemoteData exposing (RemoteData(..))
import Time


type alias Model =
    { session : UnknownSession
    , articles : RequestResponse (List Article)
    }


init : UnknownSession -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , articles = Loading
      }
    , listArticlesRequest CompletedLoadArticles
    )


type Msg
    = CompletedLoadArticles (RequestResponse (List Article))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadArticles articles ->
            ( { model | articles = articles }, Cmd.none )


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
                [ div [ class "col-md-9" ] (feedToggle model.session.user :: articleList model.articles)
                , viewPopularTags
                ]
            ]
        ]


articleList : RequestResponse (List Article) -> List (Html Msg)
articleList articles =
    case articles of
        Success ( _, [] ) ->
            [ row [ text "No articles are here... yet." ] ]

        Success ( _, data ) ->
            List.map (\article -> row (articleContent article)) data

        Failure error ->
            List.map text <| decodeErrors error

        Loading ->
            [ row [ text "Loading articles..." ] ]

        NotAsked ->
            [ row [ text "No articles are here... yet." ] ]


row : List (Html Msg) -> Html Msg
row rowContent =
    div [ class "article-preview" ]
        rowContent


articleContent : Article -> List (Html Msg)
articleContent article =
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


feedToggle : Maybe User -> Html Msg
feedToggle user =
    let
        userFeedToggle =
            case user of
                Just _ ->
                    li [ class "nav-item" ]
                        [ a [ class "nav-link", href "" ]
                            [ text "Your Feed" ]
                        ]

                Nothing ->
                    Html.nothing
    in
    div [ class "feed-toggle" ]
        [ ul [ class "nav nav-pills outline-active" ]
            [ userFeedToggle
            , li [ class "nav-item" ]
                [ a [ class "nav-link active", href "" ]
                    [ text "Global Feed" ]
                ]
            ]
        ]


viewPopularTags : Html Msg
viewPopularTags =
    div [ class "col-md-3" ]
        [ div [ class "sidebar" ]
            [ p []
                [ text "Popular Tags" ]
            , div [ class "tag-list" ]
                [ a [ href "", class "tag-pill tag-default" ]
                    [ text "placeholder tag" ]
                ]
            ]
        ]


viewBanner : Html msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ]
                [ text "conduit" ]
            , p []
                [ text "A place to share your knowledge." ]
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


toSession : Model -> UnknownSession
toSession model =
    model.session
