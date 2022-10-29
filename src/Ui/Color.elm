module Ui.Color exposing
    ( fromHex
    , toCssColor
    , toElementColor
    )

{-| Color helper functions
@docs toCssColor, toElementColor, fromHex
-}

import Color exposing (Color, fromRgba, toRgba)
import Css
import Element


{-| Interprets a color as a CSS color
-}
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

{-| Interprets a color as an Element Color
-}
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


{-| Returns a Color given a valid hex `String`
-}
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
