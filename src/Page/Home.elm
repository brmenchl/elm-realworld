module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Api exposing (RequestResponse, decodeErrors)
import Api.Article exposing (listArticlesRequest)
import Api.Tag exposing (listTagsRequest)
import Asset exposing (src)
import DateFormat
import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Html.Extra as Html
import Model.Article exposing (Article)
import Model.Session exposing (UnknownSession)
import Model.Tag exposing (Tag, tagName)
import Model.User exposing (User)
import RemoteData exposing (RemoteData(..))
import Time


type alias Model =
    { session : UnknownSession
    , articles : RequestResponse (List Article)
    , tags : RequestResponse (List Tag)
    }


init : UnknownSession -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , articles = Loading
      , tags = Loading
      }
    , Cmd.batch
        [ listArticlesRequest CompletedLoadArticles
        , listTagsRequest CompletedLoadTags
        ]
    )


type Msg
    = CompletedLoadArticles (RequestResponse (List Article))
    | CompletedLoadTags (RequestResponse (List Tag))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadArticles articles ->
            ( { model | articles = articles }, Cmd.none )

        CompletedLoadTags tags ->
            ( { model | tags = tags }, Cmd.none )



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
                [ div [ class "col-md-9" ] (feedToggle model.session.user :: articleList model.articles)
                , viewPopularTags model.tags
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


viewPopularTags : RequestResponse (List Tag) -> Html Msg
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

                    Success ( _, [] ) ->
                        [ text "No tags are here... yet." ]

                    Success ( _, tagList ) ->
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
