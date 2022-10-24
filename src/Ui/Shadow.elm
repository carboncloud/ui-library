module Ui.Shadow exposing
    ( ShadowSize(..)
    , shadow
    )

import Css exposing (Color)
import List.Nonempty as Nonempty exposing (Nonempty(..))


type Px
    = Px Int


type alias Shadow =
    { offsetX : Px
    , offsetY : Px
    , blurRadius : Px
    , spreadRadius : Px
    , color : Color
    }


type ShadowSize
    = Large
    | Small


shadow : ShadowSize -> Css.Style
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
                      , offsetY = Px 4
                      , blurRadius = Px 4
                      , spreadRadius = Px 0
                      , color = Css.rgba 0 0 0 0.11
                      }
                    , { offsetX = Px 0
                      , offsetY = Px 6
                      , blurRadius = Px 8
                      , spreadRadius = Px 0
                      , color = Css.rgba 0 0 0 0.11
                      }
                    , { offsetX = Px 0
                      , offsetY = Px 8
                      , blurRadius = Px 16
                      , spreadRadius = Px 0
                      , color = Css.rgba 0 0 0 0.11
                      }
                    ]


toStyle : Nonempty Shadow -> Css.Style
toStyle =
    Css.property "box-shadow" << String.join ", " << List.map toString << Nonempty.toList


toString : Shadow -> String
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
