module Ui.Internal.TextColor exposing (..)

import Color exposing (Color)
import Ui.Color
{-| Represents a font color
-}
type TextColor
    = Primary
    | PrimaryWhite
    | Disabled


{-| Return the color of a font
-}
textColor : TextColor -> Color
textColor color =
    case color of
        Primary ->
            Ui.Color.fromHex "#161616"

        PrimaryWhite ->
            Ui.Color.fromHex "#FCFCFC"

        Disabled ->
            Ui.Color.fromHex "#757575"
