module Page.Profile exposing (Model, Msg, init, toSession, update, view)

import Api exposing (WebData)
import Api.Profile exposing (loadProfileRequest)
import Html exposing (Html, a, button, div, h4, i, img, li, p, text, ul)
import Html.Attributes exposing (class, href)
import Html.Extra as Html
import Image exposing (src)
import Model.Article exposing (Article)
import Model.Profile exposing (Profile)
import Model.Session exposing (Session)
import Model.Slug exposing (Slug)
import Model.Username as Username exposing (Username)
import RemoteData exposing (RemoteData(..))
import View.Article exposing (viewArticlePreviewList)



--Model


type alias Model =
    { session : Session
    , username : Username
    , profile : WebData Profile
    , articles : WebData (List Article)
    }


init : Session -> Username -> ( Model, Cmd Msg )
init session username =
    ( { session = session
      , username = username
      , profile = Loading
      , articles = Loading
      }
    , loadProfileRequest CompletedLoadProfile username
    )



-- Update


type Msg
    = CompletedLoadProfile (WebData Profile)
    | Test Slug


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadProfile profile ->
            ( { model | profile = profile }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- View


view : Model -> { title : String, content : Html Msg }
view model =
    { title = Username.toHandle model.username
    , content = content model
    }


content : Model -> Html Msg
content model =
    case model.profile of
        Loading ->
            Html.nothing

        NotAsked ->
            Html.nothing

        Failure _ ->
            Html.nothing

        Success profile ->
            div [ class "profile-page" ]
                [ profileInfo profile
                , div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-xs-12 col-md-10 offset-md-1" ]
                            (articlesToggle :: viewArticlePreviewList Test model.articles)
                        ]
                    ]
                ]


profileInfo : Profile -> Html Msg
profileInfo profile =
    let
        usernameText =
            Username.toString profile.username
    in
    div [ class "user-info" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12 col-md-10 offset-md-1" ]
                    [ img [ src profile.image, class "user-img" ] []
                    , h4 [] [ text usernameText ]
                    , p [] [ text (Maybe.withDefault "" profile.bio) ]
                    , button [ class "btn btn-sm btn-outline-secondary action-btn" ]
                        [ i [ class "ion-plus-round" ] []
                        , text ("Follow " ++ usernameText)
                        ]
                    ]
                ]
            ]
        ]


articlesToggle : Html Msg
articlesToggle =
    div [ class "articles-toggle" ]
        [ ul [ class "nav nav-pills outline-active" ]
            [ li [ class "nav-item" ]
                [ a [ class "nav-link active", href "" ]
                    [ text "My Articles" ]
                ]
            , li [ class "nav-item" ]
                [ a [ class "nav-link", href "" ]
                    [ text "Favorited Articles" ]
                ]
            ]
        ]



-- Session


toSession : Model -> Session
toSession =
    .session
