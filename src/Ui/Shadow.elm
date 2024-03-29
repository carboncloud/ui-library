module Ui.Shadow exposing (shadow, Shadow(..), focus)

{-|

    # Shadow

This module defines the `Shadow` type
that is an abstraction over layered shadows.

@docs shadow, Shadow, focus

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


{-|

    Size of the shadow

-}
type Shadow
    = Large
    | Small


{-|

    Creates a focus style

-}
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


{-|

    Creates a shadow style

-}
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
                    , offsetY = Px 1
                    , blurRadius = Px 1
                    , spreadRadius = Px 0
                    , color = Css.rgba 0 0 0 0.11
                    }
                    [ { offsetX = Px 0
                      , offsetY = Px 2
                      , blurRadius = Px 2
                      , spreadRadius = Px 0
                      , color = Css.rgba 0 0 0 0.11
                      }
                    , { offsetX = Px 0
                      , offsetY = Px 6
                      , blurRadius = Px 8
                      , spreadRadius = Px 0
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
