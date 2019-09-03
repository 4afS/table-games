module Card exposing (..)

import Util


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


ranks : List Rank
ranks =
    [ Ace
    , Two
    , Three
    , Four
    , Five
    , Six
    , Seven
    , Eight
    , Nine
    , Ten
    , Jack
    , Queen
    , King
    ]


suits : List Suit
suits =
    [ Spade
    , Diamond
    , Club
    , Heart
    ]


generateDeck : List Card
generateDeck =
    Util.andThen suits <| \suit -> Util.andThen ranks <| \rank -> [ Card suit rank ]
