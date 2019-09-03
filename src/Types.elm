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
