module Api.Tag exposing (listTagsRequest)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Model.Tag exposing (Tag, listDecoder)


listTagsRequest : (RequestResponse (List Tag) -> msg) -> Cmd msg
listTagsRequest toMsg =
    Api.get
        { endpoint = Endpoint.tags
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = listDecoder
        }
