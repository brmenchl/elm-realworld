module Api.Tag exposing (listTagsRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Model.Tag exposing (Tag, listDecoder)


listTagsRequest : (WebData (List Tag) -> msg) -> Cmd msg
listTagsRequest toMsg =
    Api.get
        { endpoint = Endpoint.tags
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = listDecoder
        }
