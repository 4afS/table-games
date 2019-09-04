module Main exposing (init, main)

import Browser exposing (..)
import Card exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
import Model exposing (..)
import Msg exposing (..)
import Random exposing (..)
import Random.List exposing (..)
import String
import Types exposing (..)
import Maybe exposing (..)


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
      , deck = generateDeck
      , gameStates = Init
      , player = { hands = [], points = Points 0 }
      }
    , Cmd.map (always Shuffle) Cmd.none
    )


calcPoints_ : Card -> Points -> Points
calcPoints_ card point =
    case point of
        Bust ->
            Bust

        Points c ->
            let
                rankPoint =
                    rankToInt card.rank
            in
            if rankPoint + c > 21 then
                Bust

            else
                Points rankPoint

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
        Shuffle ->
            ( model, generate ConstructDeck (shuffle model.deck) )

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
                playersDraw = List.take 1 model.deck

            in
                ( { model |
                    deck = List.drop 1 model.deck
                  , player = updatePlayer model playersDraw
                  }
                , Cmd.none)


        Stand ->
            let
                tailwithDefault : List Card -> List Card
                tailwithDefault array =
                    List.tail array |>
                        withDefault [{suit = Diamond, rank = Ace}]

                dealDraw : List Card -> List Card -> List Card
                dealDraw deck cards =
                    let
                        currentPoints = calcPoints (Points 0) cards
                    in
                    case currentPoints of
                        Points p ->
                            if p < 17 then
                                dealDraw tailwithDefault deck <| (List.append cards <| List.take 1 deck)
                            else
                                cards
                        Bust ->
                            cards


                dealersHands = dealDraw model.deck model.dealer.hands
                currentDealersPoint = calcPoints (Points 0) dealersHands

                judgeGames : Points -> Points -> States
                judgeGames dealersPoint playersPoint =
                    case dealersPoint of
                        Bust ->
                            case playersPoint of
                                Bust ->
                                    Finish Draw
                                Points pp ->
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
            ( { model |
                    dealer = updateDealer model dealersHands
                  , gameStates = judgeGames currentDealersPoint model.player.points
            }
            , Cmd.none)

        Reset ->
            ( { model |
                gameStates = Init
              , dealer = { hands = [], points = Points 0 }
              , player = { hands = [], points = Points 0 }
            }
            , Cmd.map (always Shuffle) Cmd.none
            )




subscriptions : Model -> Sub Msg
subscriptions model =
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
                , text <| "Player : " ++ rankOfHandsToString model.player.hands
                , text <| "Dealer : " ++ rankOfHandsToString model.dealer.hands
                ]

            Finish judge ->
                [ button
                    [ onClick Reset
                    , class "reset"
                    ]
                    [ text "Reset" ]
                , text <| "You" ++ judgeToString judge
                ]


rankOfHandsToString : List Card -> String
rankOfHandsToString hands =
    List.map .rank hands
        |> List.map rankToString
        |> String.join " "


judgeToString : Judge -> String
judgeToString judge =
    case judge of
        Win ->
            "Win"

        Draw ->
            "Draw"

        Lose ->
            "Lose"
