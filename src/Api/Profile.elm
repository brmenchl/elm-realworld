module Api.Profile exposing (loadProfileRequest)

import Api exposing (RequestResponse)
import Api.Endpoint as Endpoint
import Model.Profile as Profile exposing (Profile)
import Model.Username exposing (Username)


loadProfileRequest : (RequestResponse Profile -> msg) -> Username -> Cmd msg
loadProfileRequest toMsg username =
    Api.get
        { endpoint = Endpoint.profile username
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = Profile.decoder
        }
