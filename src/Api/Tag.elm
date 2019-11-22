module Api.Tag exposing (listTagsRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Json.Decode exposing (field, list)
import Model.Tag exposing (Tag, decoder)


listTagsRequest : (WebData (List Tag) -> msg) -> Cmd msg
listTagsRequest toMsg =
    Api.get
        { endpoint = Endpoint.tags
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = field "tags" (list decoder)
        }
