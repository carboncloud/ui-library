module Ui.Color exposing
    ( fromHex
    , toCssColor
    , toElementColor
    )

import Color exposing (Color, fromHsla, fromRgba, hsl, hsla, rgb, rgb255, rgba, toCssString, toHsla, toRgba)
import Css
import Element


toCssColor : Color -> Css.Color
toCssColor =
    (\{ red, green, blue, alpha } ->
        Css.rgba
            (round <| red * 255)
            (round <| green * 255)
            (round <| blue * 255)
            alpha
    )
        << toRgba


toElementColor : Color -> Element.Color
toElementColor =
    (\{ red, green, blue, alpha } ->
        Element.rgba255
            (round red)
            (round green)
            (round blue)
            alpha
    )
        << toRgba


fromHex : String -> Color
fromHex hexString =
    let
        { red, green, blue, alpha } =
            Css.hex hexString
    in
    fromRgba
        { red = toFloat red / 255
        , green = toFloat green / 255
        , blue = toFloat blue / 255
        , alpha = alpha
        }
