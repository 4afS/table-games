module Card exposing (Card, Rank(..), Suit(..), cardToChar, generateDeck, rankToInt, rankToString, suitToInt, suitToString)

import Char exposing (fromCode)
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


rankToInt : Rank -> Int
rankToInt rank =
    case rank of
        Ace ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4

        Five ->
            5

        Six ->
            6

        Seven ->
            7

        Eight ->
            8

        Nine ->
            9

        Ten ->
            10

        Jack ->
            11

        Queen ->
            12

        King ->
            13


rankToString : Rank -> String
rankToString rank =
    case rank of
        Ace ->
            "Ace"

        Two ->
            "Two"

        Three ->
            "Three"

        Four ->
            "Four"

        Five ->
            "Five"

        Six ->
            "Six"

        Seven ->
            "Seven"

        Eight ->
            "Eight"

        Nine ->
            "Nine"

        Ten ->
            "Ten"

        Jack ->
            "Jack"

        Queen ->
            "Queen"

        King ->
            "King"


suitToInt : Suit -> Int
suitToInt suit =
    case suit of
        Spade ->
            1

        Diamond ->
            2

        Club ->
            3

        Heart ->
            4


suitToString : Suit -> String
suitToString suit =
    case suit of
        Spade ->
            "Spade"

        Diamond ->
            "Diamond"

        Club ->
            "Club"

        Heart ->
            "Heart"


cardToChar : Card -> Char
cardToChar card =
    case card.suit of
        Spade ->
            let
                base =
                    0x0001F0A0
            in
            fromCode <| base + rankToInt card.rank

        Diamond ->
            let
                base =
                    0x0001F0C0
            in
            fromCode <| base + rankToInt card.rank

        Club ->
            let
                base =
                    0x0001F0D0
            in
            fromCode <| base + rankToInt card.rank

        Heart ->
            let
                base =
                    0x0001F0B0
            in
            fromCode <| base + rankToInt card.rank
