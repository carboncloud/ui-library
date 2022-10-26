module Ui.Element.Palette exposing (..)

import Element
import Ui.Color as Color exposing (Color)


fromColor : Color -> Element.Color
fromColor =
    (\{ red, green, blue, alpha } ->
        Element.rgba255
            (round red)
            (round green)
            (round blue)
            alpha
    )
        << Color.toRgba
