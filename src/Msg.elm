module Msg exposing (..)

import Types exposing (..)
import Card exposing (..)

type Msg
    = Shuffle
    | ConstructDeck (List Card)
    | Start
    | Hit
    | Stand
    | Reset
