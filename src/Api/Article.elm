module Api.Article exposing (favoriteArticleRequest, feedArticlesRequest, listArticlesRequest, loadArticleRequest, unfavoriteArticleRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Json.Decode exposing (field, list)
import Model.Article as Article exposing (Article)
import Model.Credentials exposing (Credentials)
import Model.Slug exposing (Slug)
import Url.Builder exposing (QueryParameter)


listArticlesRequest : (WebData (List Article) -> msg) -> Cmd msg
listArticlesRequest toMsg =
    Api.get
        { endpoint = Endpoint.articles (paginatedListQueryParams { page = 1, limit = 10 })
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = field "articles" (list Article.decoder)
        }


feedArticlesRequest : (WebData (List Article) -> msg) -> Credentials -> Cmd msg
feedArticlesRequest toMsg credentials =
    Api.get
        { endpoint = Endpoint.feed (paginatedListQueryParams { page = 1, limit = 10 })
        , credentials = Just credentials
        , toMsg = toMsg
        , decoder = field "articles" (list Article.decoder)
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
