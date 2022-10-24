module Ui.Palette exposing (Palette, palette, map)

import Ui.Color as Color exposing (Color, rgb)



-- TODO: confirm colors

type alias Palette color = { primary050 : color
        , primary500 : color
        , primary600 : color
        , secondary050 : color
        , secondary500 : color
        , secondary600 : color
        , grey050 : color
        , grey100 : color
        , grey200 : color
        , grey300 : color
        , grey500 : color
        , grey800 : color
        , white : color
        , black : color
        , success : color
        , warn050 : color
        , warn500 : color
        , warn600 : color
        , focus : color
        , success050 : color
        } 
palette : Palette Color
palette =
        { primary050 = hex "#CAE8E9"
        , primary500 = hex "#00787d"
        , primary600 = hex "#287387"
        , secondary050 = hex "#E6E8F5"
        , secondary500 = hex "#364286"
        , secondary600 = hex "#2F3974"
        , grey050 = hex "#FCFCFC"
        , grey100 = hex "#f8f8f8"
        , grey200 = hex "#E3E3E3"
        , grey300 = hex "#e8e8e8"
        , grey500 = hex "#858585"
        , grey800 = hex "#464646"
        , white = hex "#ffffff"
        , black = hex "#05050a"
        , success = hex "#b5f7b5"
        , warn050 = hex "#FEEFEC"
        , warn500 = hex "#fa876a"
        , warn600 = hex "#D95E3F"
        , focus = hex "#172D69"
        , success050 = hex "#172D69"
        }


map : (a -> b) -> Palette a -> Palette b
map f p = { primary050 = f p.primary050
        , primary500 = f p.primary500
        , primary600 = f p.primary600
        , secondary050 = f p.secondary050
        , secondary500 = f p.secondary500
        , secondary600 = f p.secondary600
        , grey050 = f p.grey050
        , grey100 = f p.grey100
        , grey200 = f p.grey200
        , grey300 = f p.grey300
        , grey500 = f p.grey500
        , grey800 = f p.grey800
        , white = f p.white
        , black = f p.black
        , success = f p.success
        , warn050 = f p.warn050
        , warn500 = f p.warn500
        , warn600 = f p.warn600
        , focus = f p.focus
        , success050 = f p.success050
        }


hex : String -> Color
hex =
    Maybe.withDefault (rgb 1 0 0) << Color.fromHex
