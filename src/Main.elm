module Main exposing (init, main)

import Browser exposing (..)
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
      , gameStatus = Init
      , dealer = Dealer { hands = [], points = Points 0 }
      , player = Player { hands = [], points = Points 0 }
      }
    , shuffle model.deck |> generate ConstructDeck
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConstructDeck shuffledDeck ->
            ({ model
                | deck = shuffledDeck
            }
            Cmd.none)

        Start ->
            let
                initCard = List.take (2 * 2) model.deck

                playersDraw =
                    List.take 2 initCard

                dealersDraw =
                    List.drop 2 initCard

                calcPoints : Points -> List Card -> Points
                calcPoints point cards =
                    case point of
                        Bust ->
                            Bust

                        Points p ->



            in
                ({ model |
                    deck = List.drop 4 model.deck
                  , {dealer | hands = }



                })

        Hit ->

        Stand ->

        Reset ->





subscriptions : Model -> Sub Msg


view : Model -> Html Msg
