module Main exposing (init, main)

import Browser exposing (..)
import Card exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
import Maybe exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Random exposing (..)
import Random.List exposing (..)
import String
import Types exposing (..)
import Cmd.Extra exposing (..)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { dealer = { hands = [], points = Points 0 }
      , deck = []
      , gameStates = Init
      , player = { hands = [], points = Points 0 }
      }
    , generate ConstructDeck (shuffle generateDeck)
    )


cardToPoint : Card -> Int
cardToPoint card =
    let
        rankAsInt =
            rankToInt card.rank
    in
    if rankAsInt > 10 then
        10

    else
        rankAsInt


calcPoints_ : Card -> Points -> Points
calcPoints_ card point =
    case point of
        Bust ->
            Bust

        Points c ->
            let
                rankPoint =
                    cardToPoint card
            in
            if rankPoint + c > 21 then
                Bust

            else
                Points <| rankPoint + c


calcPoints : Points -> List Card -> Points
calcPoints point cards =
    case point of
        Bust ->
            Bust

        Points p ->
            List.foldl calcPoints_ (Points p) cards


updateDealer : Model -> List Card -> Player
updateDealer model dealersDraw =
    let
        newDealer =
            { hands = List.append model.dealer.hands dealersDraw
            , points = calcPoints model.dealer.points dealersDraw
            }
    in
    newDealer


updatePlayer : Model -> List Card -> Player
updatePlayer model playersDraw =
    let
        newPlayer =
            { hands = List.append model.player.hands playersDraw
            , points = calcPoints model.player.points playersDraw
            }
    in
    newPlayer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConstructDeck shuffledDeck ->
            ( { model
                | deck = shuffledDeck
              }
            , Cmd.none
            )

        Start ->
            let
                initCard =
                    List.take (2 * 2) model.deck

                playersDraw =
                    List.take 2 initCard

                dealersDraw =
                    List.drop 2 initCard
            in
            ( { model
                | deck = List.drop 4 model.deck
                , gameStates = Playing
                , dealer = updateDealer model dealersDraw
                , player = updatePlayer model playersDraw
              }
            , Cmd.none
            )

        Hit ->
            let
                playersDraw =
                    List.take 1 model.deck

                currentPlayersPoint =
                    calcPoints model.player.points playersDraw

            in
            case currentPlayersPoint of
                Points p ->
                    ( { model
                        | deck = List.drop 1 model.deck
                        , player = updatePlayer model playersDraw
                      }
                    , Cmd.none
                    )

                Bust ->
                    ( { model
                        | deck = List.drop 1 model.deck
                        , player = updatePlayer model playersDraw
                      }
                    , perform Stand
                    )


        Stand ->
            let
                tailWithDefault : List Card -> List Card
                tailWithDefault array =
                    List.tail array
                        |> withDefault [ { suit = Diamond, rank = Ace } ]

                dealDraw : List Card -> List Card -> List Card
                dealDraw deck cards =
                    let
                        currentPoints =
                            calcPoints (Points 0) cards
                    in
                    case currentPoints of
                        Points p ->
                            if p < 17 then
                                dealDraw (tailWithDefault deck) (List.append cards <| List.take 1 deck)

                            else
                                cards

                        Bust ->
                            cards

                dealersHands =
                    dealDraw model.deck model.dealer.hands

                currentDealersPoint =
                    calcPoints (Points 0) dealersHands

                judgeGames : Points -> Points -> States
                judgeGames dealersPoint playersPoint =
                    case dealersPoint of
                        Bust ->
                            case playersPoint of
                                Bust ->
                                    Finish Draw

                                Points _ ->
                                    Finish Win

                        Points dp ->
                            case playersPoint of
                                Bust ->
                                    Finish Lose

                                Points pp ->
                                    if dp < pp then
                                        Finish Win

                                    else if dp > pp then
                                        Finish Lose

                                    else
                                        Finish Draw
            in
            ( { model
                | dealer = updateDealer model <| List.drop 2 dealersHands
                , gameStates = judgeGames currentDealersPoint model.player.points
              }
            , Cmd.none
            )

        Reset ->
            ( { model
                | gameStates = Init
                , dealer = { hands = [], points = Points 0 }
                , player = { hands = [], points = Points 0 }
              }
            , generate ConstructDeck (shuffle generateDeck)
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div
        [ class "main" ]
    <|
        case model.gameStates of
            Init ->
                [ button
                    [ onClick Start
                    , class "start"
                    ]
                    [ text "Start!" ]
                ]

            Playing ->
                [ button
                    [ onClick Hit
                    , class "hit"
                    ]
                    [ text "Hit" ]
                , button
                    [ onClick Stand
                    , class "stand"
                    ]
                    [ text "Stand" ]
                , button
                    [ onClick Reset
                    , class "reset"
                    ]
                    [ text "Reset" ]
                , br [] []
                , text <| "Player : " ++ rankOfHandsToString model.player.hands
                , text <| "Point : " ++ pointsToString model.player.points
                , br [] []
                , text <| "Dealer : " ++ rankOfHandsToString model.dealer.hands
                , text <| "Point : " ++ pointsToString model.dealer.points
                ]

            Finish judge ->
                [ button
                    [ onClick Reset
                    , class "reset"
                    ]
                    [ text "Reset" ]
                , text <| "You" ++ judgeToString judge
                , br [] []
                , text <| "Player : " ++ rankOfHandsToString model.player.hands
                , text <| "Point : " ++ pointsToString model.player.points
                , br [] []
                , text <| "Dealer : " ++ rankOfHandsToString model.dealer.hands
                , text <| "Point : " ++ pointsToString model.dealer.points
                ]


rankOfHandsToString : List Card -> String
rankOfHandsToString hands =
    List.map .rank hands
        |> List.map rankToString
        |> String.join " "


pointsToString : Points -> String
pointsToString points =
    case points of
        Points p ->
            String.fromInt p

        Bust ->
            "Bust"


judgeToString : Judge -> String
judgeToString judge =
    case judge of
        Win ->
            "Win"

        Draw ->
            "Draw"

        Lose ->
            "Lose"
