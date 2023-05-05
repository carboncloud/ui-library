module Ui.Color exposing (toCssColor, fromHex)

{-| Color helper functions

@docs toCssColor, fromHex

-}

import Color exposing (Color, fromRgba, toRgba)
import Css


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
