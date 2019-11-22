module Api.Profile exposing (loadProfileRequest)

import Api exposing (WebData)
import Api.Endpoint as Endpoint
import Model.Profile as Profile exposing (Profile)
import Model.Username exposing (Username)


loadProfileRequest : (WebData Profile -> msg) -> Username -> Cmd msg
loadProfileRequest toMsg username =
    Api.get
        { endpoint = Endpoint.profile username
        , credentials = Nothing
        , toMsg = toMsg
        , decoder = Profile.decoder
        }
