module Model exposing (Model)

import Card exposing (..)
import Msg exposing (..)
import Types exposing (..)


type alias Model =
    { deck : List Card
    , gameStates : States
    , dealer : Player
    , player : Player
    }
