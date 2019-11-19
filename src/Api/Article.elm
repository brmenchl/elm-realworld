module Api.Article exposing (feedArticlesRequest, listArticlesRequest)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Model.Article as Article exposing (Article, listDecoder)
import Model.Credentials exposing (Credentials)
import Url.Builder exposing (QueryParameter)


listArticlesRequest : (RequestResponse (List Article) -> msg) -> Cmd msg
listArticlesRequest toMsg =
    Api.get
        { endpoint = Endpoint.articles (paginatedListQueryParams { page = 1, limit = 10 })
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = Article.listDecoder
        }


feedArticlesRequest : (RequestResponse (List Article) -> msg) -> Credentials -> Cmd msg
feedArticlesRequest toMsg credentials =
    Api.get
        { endpoint = Endpoint.feed (paginatedListQueryParams { page = 1, limit = 10 })
        , credentials = Just credentials
        , toMsg = toMsg
        , decoder = Article.listDecoder
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
