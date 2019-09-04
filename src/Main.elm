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

                calcPoints_ : Card -> Points -> Points
                calcPoints_ card point =
                    case point of
                        Bust ->
                            Bust

                        Points c ->
                            let
                                rankPoint =
                                    fromRank card.rank
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

                updateDealer : Player
                updateDealer =
                    let
                        newDealer =
                            { hands = List.append model.dealer.hands dealersDraw
                            , points = calcPoints model.dealer.points dealersDraw
                            }
                    in
                    newDealer

                updatePlayer : Player
                updatePlayer =
                    let
                        newPlayer =
                            { hands = List.append model.player.hands playersDraw
                            , points = calcPoints model.player.points playersDraw
                            }
                    in
                    newPlayer
            in
            ( { model
                | deck = List.drop 4 model.deck
                , gameStates = Playing
                , dealer = updateDealer
                , player = updatePlayer
              }
            , Cmd.none
            )

        Hit ->
            ( model, Cmd.none )

        Stand ->
            ( model, Cmd.none )

        Reset ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [] [ text "test" ]
