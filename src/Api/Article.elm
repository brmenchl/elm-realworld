module Api.Article exposing (listArticlesRequest)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Model.Article exposing (Article, articleListDecoder)
import Url.Builder exposing (QueryParameter)


listArticlesRequest : (RequestResponse (List Article) -> msg) -> Cmd msg
listArticlesRequest toMsg =
    Api.get
        { endpoint = Endpoint.articles (paginatedListQueryParams { page = 1, limit = 10 })
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = articleListDecoder
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
