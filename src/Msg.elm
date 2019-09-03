module Msg exposing (..)

import Card exposing (..)
import Types exposing (..)


type Msg
    = ConstructDeck (List Card)
    | Start
    | Hit
    | Stand
    | Reset
