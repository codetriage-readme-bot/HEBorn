module Decoders.Bounces exposing (..)

import Json.Decode as Decode
    exposing
        ( Decoder
        , dict
        , list
        , string
        , field
        )
import Json.Decode.Pipeline exposing (decode, required, custom)
import Game.Account.Bounces.Models exposing (..)
import Game.Account.Bounces.Shared exposing (..)
import Game.Meta.Types.Network exposing (NIP)


bounces : Decoder Model
bounces =
    dict bounce


bounce : Decoder Bounce
bounce =
    decode Bounce
        |> required "name" string
        |> required "links" (list nip)


nip : Decoder NIP
nip =
    decode (,)
        |> required "network_id" string
        |> required "ip" string


bounceId : Decoder ID
bounceId =
    field "bounce_id" string


bounceWithId : Decoder ( ID, Bounce )
bounceWithId =
    decode (,)
        |> custom bounceId
        |> custom bounce
