module Ui.Css.Palette exposing (palette)

import Css
import Ui.Color as Color exposing (Color)
import Ui.Palette exposing (Palette)

palette : { primary050 : Css.Color
        , primary500 : Css.Color
        , primary600 : Css.Color
        , secondary050 : Css.Color
        , secondary500 : Css.Color
        , secondary600 : Css.Color
        , grey050 : Css.Color
        , grey100 : Css.Color
        , grey200 : Css.Color
        , grey300 : Css.Color
        , grey500 : Css.Color
        , grey800 : Css.Color
        , white : Css.Color
        , black : Css.Color
        , success : Css.Color
        , warn050 : Css.Color
        , warn500 : Css.Color
        , warn600 : Css.Color
        , focus : Css.Color
        , success050 : Css.Color
        }
palette = Ui.Palette.map fromColor Ui.Palette.palette

fromColor : Color -> Css.Color
fromColor =
    (\{ red, green, blue, alpha } ->
        Css.rgba
            (round <| red * 255)
            (round <| green * 255)
            (round <| blue * 255)
            alpha
    ) << Color.toRgba
