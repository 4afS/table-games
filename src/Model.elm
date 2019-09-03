module Model exposing (Model)

import Msg exposing (..)
import Card exposing (..)
import Types exposing (..)

type alias Model =
    { deck : List Card
    , gameStatus : States
    , dealer : Player
    , player : Player
    }
