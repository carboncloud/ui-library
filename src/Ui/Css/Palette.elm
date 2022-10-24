module Ui.Css.Palette exposing (palette)

import Css
import Ui.Color as Color exposing (Color)
import Ui.Palette exposing (Palette)

palette : Palette Css.Color
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
