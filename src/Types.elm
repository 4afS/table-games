module Types exposing (..)

import Card exposing (Card)


type alias Player =
    { hands : List Card
    , points : Points
    }


type alias Dealer =
    { hands : List Card
    , points : Points
    }


type Points
    = Bust
    | Points Int


type States
    = Init
    | Playing
    | Finish Judge


type Judge
    = Win
    | Draw
    | Lose
