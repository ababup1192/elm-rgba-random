port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random as Random



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Color =
    { red : Int
    , green : Int
    , blue : Int
    , alpha : Float
    }


type alias Model =
    { color : Color
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Color 0 0 0 1.0), genRGBA )



-- ---------------------------
-- UPDATE
-- ---------------------------


rgbaGenerator : Random.Generator Color
rgbaGenerator =
    Random.map4 Color
        (Random.int 0 255)
        (Random.int 0 255)
        (Random.int 0 255)
        (Random.float 0 1.0)


genRGBA : Cmd Msg
genRGBA =
    Random.generate GeneratedRGBA rgbaGenerator


type Msg
    = GeneratedRGBA Color
    | GenerateRGBA


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GeneratedRGBA color ->
            ( { model | color = color }, Cmd.none )

        GenerateRGBA ->
            ( model, genRGBA )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view { color } =
    let
        { red, green, blue, alpha } =
            color

        rgba =
            String.join ","
                [ String.fromInt red
                , String.fromInt green
                , String.fromInt blue
                , String.fromInt alpha
                ]
    in
    div [ class "container" ]
        [ button [ onClick GenerateRGBA ] [ text "Generate Random" ]
        , div
            [ class "colorPanel", style "background" <| "rgba(" ++ rgba ++ ")" ]
            []
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "RGBA"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
