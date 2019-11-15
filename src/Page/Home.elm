module Page.Home exposing (Model, init, toSession, view)

import Html exposing (Html, a, button, div, h1, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src)
import Session exposing (Session)


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( Model session, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session


view : { title : String, content : Html msg }
view =
    { title = "Home"
    , content = content
    }


content : Html msg
content =
    div [ class "home-page" ]
        [ viewBanner
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ]
                    [ div [ class "feed-toggle" ]
                        [ ul [ class "nav nav-pills outline-active" ]
                            [ li [ class "nav-item" ]
                                [ a [ class "nav-link disabled", href "" ]
                                    [ text "Your Feed" ]
                                ]
                            , li [ class "nav-item" ]
                                [ a [ class "nav-link active", href "" ]
                                    [ text "Global Feed" ]
                                ]
                            ]
                        ]
                    , div [ class "article-preview" ]
                        [ div [ class "article-meta" ]
                            [ a [ href "profile.html" ]
                                [ img [ src "http://i.imgur.com/Qr71crq.jpg" ]
                                    []
                                ]
                            , div [ class "info" ]
                                [ a [ href "", class "author" ]
                                    [ text "Eric Simons" ]
                                , span [ class "date" ]
                                    [ text "January 20th" ]
                                ]
                            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                                [ i [ class "ion-heart" ] []
                                , text "29"
                                ]
                            ]
                        , a [ href "", class "preview-link" ]
                            [ h1 []
                                [ text "How to build webapps that scale" ]
                            , p []
                                [ text "This is the description for the post." ]
                            , span []
                                [ text "Read more..." ]
                            ]
                        ]
                    , div [ class "article-preview" ]
                        [ div [ class "article-meta" ]
                            [ a [ href "profile.html" ]
                                [ img [ src "http://i.imgur.com/N4VcUeJ.jpg" ]
                                    []
                                ]
                            , div [ class "info" ]
                                [ a [ href "", class "author" ]
                                    [ text "Albert Pai" ]
                                , span [ class "date" ]
                                    [ text "January 20th" ]
                                ]
                            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                                [ i [ class "ion-heart" ] []
                                , text "32"
                                ]
                            ]
                        , a [ href "", class "preview-link" ]
                            [ h1 []
                                [ text "The song you won't ever stop singing. No matter how hard you try." ]
                            , p []
                                [ text "This is the description for the post." ]
                            , span []
                                [ text "Read more..." ]
                            ]
                        ]
                    ]
                , viewPopularTags
                ]
            ]
        ]


viewPopularTags : Html msg
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
