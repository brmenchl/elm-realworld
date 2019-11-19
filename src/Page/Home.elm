module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Api exposing (RequestResponse)
import Api.Article exposing (feedArticlesRequest, listArticlesRequest)
import Api.Tag exposing (listTagsRequest)
import Html exposing (Html, a, div, h1, li, p, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.Extra as Html
import Model.Article exposing (Article)
import Model.Session exposing (UnknownSession)
import Model.Tag exposing (Tag, tagName)
import Model.User exposing (User)
import RemoteData exposing (RemoteData(..))
import View.Article exposing (viewArticlePreviewList)


type FeedType
    = Personal
    | Global


type alias Model =
    { session : UnknownSession
    , articles : RequestResponse (List Article)
    , tags : RequestResponse (List Tag)
    , feedType : FeedType
    }


init : UnknownSession -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , articles = Loading
      , tags = Loading
      , feedType = Global
      }
    , Cmd.batch
        [ listArticlesRequest CompletedLoadArticles
        , listTagsRequest CompletedLoadTags
        ]
    )


type Msg
    = CompletedLoadArticles (RequestResponse (List Article))
    | CompletedLoadTags (RequestResponse (List Tag))
    | ChangeFeedType FeedType


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadArticles articles ->
            ( { model | articles = articles }, Cmd.none )

        CompletedLoadTags tags ->
            ( { model | tags = tags }, Cmd.none )

        ChangeFeedType feedType ->
            case feedType of
                Personal ->
                    case model.session.user of
                        Just u ->
                            ( { model | articles = Loading, feedType = feedType }, feedArticlesRequest CompletedLoadArticles u.credentials )

                        Nothing ->
                            ( model, Cmd.none )

                Global ->
                    ( { model | articles = Loading, feedType = feedType }, listArticlesRequest CompletedLoadArticles )



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
                [ div [ class "col-md-9" ] (feedToggle model.session.user model.feedType :: viewArticlePreviewList model.articles)
                , viewPopularTags model.tags
                ]
            ]
        ]


feedToggle : Maybe User -> FeedType -> Html Msg
feedToggle user currentFeedType =
    let
        feedToggleItem ( title, feedType ) =
            li [ class "nav-item" ]
                [ a [ classList [ ( "nav-link", True ), ( "active", currentFeedType == feedType ) ], href "", onClick (ChangeFeedType feedType) ] [ text title ]
                ]

        userFeedToggle =
            case user of
                Just _ ->
                    [ ( "Your Feed", Personal ) ]

                Nothing ->
                    []
    in
    div [ class "feed-toggle" ]
        [ ul [ class "nav nav-pills outline-active" ] <|
            List.map feedToggleItem (List.append userFeedToggle [ ( "Global Feed", Global ) ])
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



-- Session


toSession : Model -> UnknownSession
toSession =
    .session
