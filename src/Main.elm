module Main exposing (init, main)

import Browser exposing (..)
import Card exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
import Model exposing (..)
import Msg exposing (..)
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
    ( { deck = generateDeck
      , gameStates = Init
      , dealer = Dealer { hands = [], points = Points 0 }
      , player = Player { hands = [], points = Points 0 }
      }
    , shuffle model.deck |> generate ConstructDeck
    )


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

                calcPoints_ : Points -> Card -> Points
                calcPoints_ point card =
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
            in
            ( { model
                | deck = List.drop 4 model.deck
                , gameStates = Playing
                , dealer =
                    Dealer <|
                        List.append model.dealer.hands dealersDraw <|
                            calcPoints model.dealer.points dealersDraw
                , player =
                    Player <|
                        List.append model.player.hands playersDraw <|
                            calcPoints model.player.points playersDraw
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
subscriptions =
    Sub.none


view : Model -> Html Msg
view =
    div [] []
