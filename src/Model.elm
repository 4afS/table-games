module Model exposing (Model)

import Msg exposing (..)

type alias Model =
    { deck : List Card
    , gameStatus : States
    , dealer : Player
    , player : Player
    }
