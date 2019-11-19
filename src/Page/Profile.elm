module Page.Profile exposing (Model, Msg, init, toSession, update, view)

import Api exposing (RequestResponse)
import Api.Profile exposing (loadProfileRequest)
import Html exposing (Html, a, button, div, h1, h4, i, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Html.Extra as Html
import Image exposing (defaultAvatar, src)
import Model.Article exposing (Article)
import Model.Profile exposing (Profile)
import Model.Session exposing (UnknownSession)
import Model.User exposing (User)
import Model.Username as Username exposing (Username)
import RemoteData exposing (RemoteData(..))
import View.Article exposing (viewArticlePreviewList)



--Model


type alias Model =
    { session : UnknownSession
    , username : Username
    , profile : RequestResponse Profile
    , articles : RequestResponse (List Article)
    }


init : UnknownSession -> Username -> ( Model, Cmd Msg )
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
    = CompletedLoadProfile (RequestResponse Profile)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CompletedLoadProfile profile ->
            ( { model | profile = profile }, Cmd.none )



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

        Success ( _, profile ) ->
            div [ class "profile-page" ]
                [ profileInfo profile
                , div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-xs-12 col-md-10 offset-md-1" ]
                            (articlesToggle :: viewArticlePreviewList model.articles)
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


toSession : Model -> UnknownSession
toSession =
    .session
