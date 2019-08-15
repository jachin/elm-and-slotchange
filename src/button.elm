module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes
import Html.Events exposing (on)
import Html.Keyed as Keyed
import Json.Decode


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Direction
    = GoingUp
    | GoingDown
    | GoingNowhere


type alias Model =
    { count : Int
    , direction : Direction
    }


init : Model
init =
    { count = 0
    , direction = GoingNowhere
    }



-- UPDATE


type Msg
    = ChangeCount Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeCount value ->
            let
                direction =
                    case value > model.count of
                        True ->
                            GoingUp

                        False ->
                            GoingDown

                _ =
                    Debug.log "Change Count" model.count
            in
            { model | count = value, direction = direction }



-- VIEW


directionToString : Direction -> String
directionToString direction =
    case direction of
        GoingUp ->
            "going up"

        GoingDown ->
            "going down"

        GoingNowhere ->
            "going nowhere"


view : Model -> Html Msg
view model =
    let
        directionSlot =
            case model.direction of
                GoingUp ->
                    div
                        [ Html.Attributes.attribute "slot" "direction-label" ]
                        [ text "Going Up" ]

                GoingDown ->
                    div
                        [ Html.Attributes.attribute "slot" "direction-label" ]
                        [ text "Going Down" ]

                GoingNowhere ->
                    div
                        [ Html.Attributes.attribute "slot" "direction-label" ]
                        [ text "Going Nowhere" ]
    in
    div []
        [ Keyed.node "up-and-down"
            [ Html.Attributes.attribute "count" (String.fromInt model.count)
            , on "countChange" <|
                Json.Decode.map ChangeCount <|
                    Json.Decode.at [ "detail", "count" ] Json.Decode.int
            ]
            [ ( String.fromInt model.count, directionSlot ) ]
        ]
