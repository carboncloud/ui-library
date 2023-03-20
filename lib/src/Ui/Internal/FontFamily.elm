module Ui.Internal.FontFamily exposing (..)

{-| Represents a font family
-}


type FontFamily
    = Primary
    | Body
    | Mono


fontFamily : FontFamily -> String
fontFamily family =
    case family of
        Primary ->
            "Poppins"

        Body ->
            "Merriweather"

        Mono ->
            Debug.todo "Add Mono font"
