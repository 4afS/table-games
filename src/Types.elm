module Types exposing (..)


type alias Card =
    { suit : Suit
    , rank : Rank
    }


type Suit
    = Spade
    | Diamond
    | Club
    | Heart


type Rank
    = Ace
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King


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
