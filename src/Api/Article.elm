module Api.Article exposing (ArticleListResponse, favoriteArticleRequest, feedArticlesRequest, listArticlesRequest, loadArticleRequest, unfavoriteArticleRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Json.Decode as Decode exposing (Decoder, field, int, list)
import Json.Decode.Pipeline exposing (required)
import Model.Article as Article exposing (Article, Slug)
import Model.Credentials exposing (Credentials)
import Url.Builder exposing (QueryParameter)
import View.PaginatedList exposing (PageDetails, getPageDetails)


type alias ArticleListResponse =
    { articles : List Article, pageDetails : PageDetails }


type alias PageRequestDetails =
    { page : Int, limit : Int }


listArticlesRequest : (WebData ArticleListResponse -> msg) -> Int -> Cmd msg
listArticlesRequest toMsg page =
    let
        pageRequestDetails =
            { page = page, limit = 10 }
    in
    Api.get
        { endpoint = Endpoint.articles (paginatedListQueryParams pageRequestDetails)
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = listDecoder pageRequestDetails
        }


feedArticlesRequest : (WebData ArticleListResponse -> msg) -> Credentials -> Cmd msg
feedArticlesRequest toMsg credentials =
    let
        pageRequestDetails =
            { page = 1, limit = 10 }
    in
    Api.get
        { endpoint = Endpoint.feed (paginatedListQueryParams pageRequestDetails)
        , credentials = Just credentials
        , toMsg = toMsg
        , decoder = listDecoder pageRequestDetails
        }


loadArticleRequest : (WebData Article -> msg) -> Slug -> Cmd msg
loadArticleRequest toMsg slug =
    Api.get
        { endpoint = Endpoint.article slug
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = field "article" Article.decoder
        }


favoriteArticleRequest : (WebData Article -> msg) -> Credentials -> Slug -> Cmd msg
favoriteArticleRequest toMsg credentials slug =
    Api.post
        { endpoint = Endpoint.articleFavorite slug
        , credentials = Just credentials
        , body = Nothing
        , toMsg = toMsg
        , decoder = field "article" Article.decoder
        }


unfavoriteArticleRequest : (WebData Article -> msg) -> Credentials -> Slug -> Cmd msg
unfavoriteArticleRequest toMsg credentials slug =
    Api.delete
        { endpoint = Endpoint.articleFavorite slug
        , credentials = Just credentials
        , toMsg = toMsg
        , decoder = field "article" Article.decoder
        }


paginatedListQueryParams : { page : Int, limit : Int } -> List QueryParameter
paginatedListQueryParams { page, limit } =
    let
        offset =
            (page - 1) * limit
    in
    [ Url.Builder.string "limit" (String.fromInt limit)
    , Url.Builder.string "offset" (String.fromInt offset)
    ]



-- decoder


toArticleListResponse : PageRequestDetails -> Int -> List Article -> ArticleListResponse
toArticleListResponse { page, limit } totalItems articles =
    { articles = articles
    , pageDetails = { currentPage = page, totalPages = round <| toFloat totalItems / toFloat limit }
    }


listDecoder : PageRequestDetails -> Decoder ArticleListResponse
listDecoder details =
    Decode.succeed (toArticleListResponse details)
        |> required "articlesCount" int
        |> required "articles" (list Article.decoder)
