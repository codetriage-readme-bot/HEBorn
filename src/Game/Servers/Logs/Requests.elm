module Game.Servers.Logs.Requests
    exposing
        ( Response(..)
        , LogResponse(..)
        , receive
        , logReceive
        )

import Game.Servers.Logs.Requests.Index as Index
import Game.Servers.Logs.Messages exposing (..)


type Response
    = Index Index.Response


type LogResponse
    = LogResponse


receive : RequestMsg -> Maybe Response
receive response =
    case response of
        IndexRequest ( code, data ) ->
            data
                |> Index.receive code
                |> Maybe.map Index


logReceive : LogRequestMsg -> Maybe LogResponse
logReceive response =
    Nothing