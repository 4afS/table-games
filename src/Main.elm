module Main exposing (init, main)

import Browser exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
import Model exposing (..)
import Random.List exposing (..)
import String


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
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )


subscriptions : Model -> Sub Msg


view : Model -> Html Msg
