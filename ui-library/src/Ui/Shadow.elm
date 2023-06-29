module Ui.Shadow exposing
    ( Shadow(..)
    , focus
    , shadow
    )

{-
   This module defines the `Shadow` type
   that is an abstraction over layered shadows.
-}

import Css exposing (Color)
import List.Nonempty as Nonempty exposing (Nonempty(..))
import Ui.Color exposing (toCssColor)
import Ui.Palette


type Px
    = Px Int


type alias ShadowSpec =
    { offsetX : Px
    , offsetY : Px
    , blurRadius : Px
    , spreadRadius : Px
    , color : Color
    }


type Shadow
    = Large
    | Small


focus : Css.Style
focus =
    toStyle <|
        Nonempty
            { offsetX = Px 0
            , offsetY = Px 0
            , blurRadius = Px 5
            , spreadRadius = Px 2
            , color = toCssColor Ui.Palette.primary500
            }
            []


shadow : Shadow -> Css.Style
shadow size =
    toStyle <|
        case size of
            Large ->
                Nonempty
                    { offsetX = Px 0
                    , offsetY = Px 10
                    , blurRadius = Px 15
                    , spreadRadius = Px 7
                    , color = Css.rgba 0 0 0 0.05
                    }
                    [ { offsetX = Px 0
                      , offsetY = Px 4
                      , blurRadius = Px 6
                      , spreadRadius = Px -2
                      , color = Css.rgba 0 0 0 0.05
                      }
                    ]

            Small ->
                Nonempty
                    { offsetX = Px 0
                    , offsetY = Px 0
                    , blurRadius = Px 1
                    , spreadRadius = Px 0
                    , color = Css.rgba 0 0 0 0.11
                    }
                    [ { offsetX = Px 1
                      , offsetY = Px 2
                      , blurRadius = Px 2
                      , spreadRadius = Px 1
                      , color = Css.rgba 0 0 0 0.11
                      }
                    , { offsetX = Px 2
                      , offsetY = Px 6
                      , blurRadius = Px 8
                      , spreadRadius = Px 2
                      , color = Css.rgba 0 0 0 0.11
                      }
                    ]


toStyle : Nonempty ShadowSpec -> Css.Style
toStyle =
    Css.property "box-shadow" << String.join ", " << List.map toString << Nonempty.toList


toString : ShadowSpec -> String
toString { offsetX, offsetY, blurRadius, spreadRadius, color } =
    let
        cssPixelVal : Px -> String
        cssPixelVal length =
            case length of
                Px 0 ->
                    "0"

                Px v ->
                    String.fromInt v ++ "px"

        fromCssColor : Css.Color -> String
        fromCssColor { red, green, blue, alpha } =
            "rgba(" ++ (String.join ", " <| List.map String.fromFloat [ toFloat red, toFloat green, toFloat blue, alpha ]) ++ ")"
    in
    String.join " "
        [ cssPixelVal offsetX
        , cssPixelVal offsetY
        , cssPixelVal blurRadius
        , cssPixelVal spreadRadius
        , fromCssColor color
        ]
