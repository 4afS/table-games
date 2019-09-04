module Msg exposing (..)

import Card exposing (..)
import Types exposing (..)


type Msg
    = Shuffle
    | ConstructDeck (List Card)
    | Start
    | Hit
    | Stand
    | Reset
