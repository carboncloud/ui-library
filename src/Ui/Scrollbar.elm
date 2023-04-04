module Ui.Scrollbar exposing (..)

import Color exposing (Color)
import Css
import Ui.Color exposing (toCssColor)


type ScrollbarWidth
    = Auto
    | Thin
    | None


scrollbarWidth : ScrollbarWidth -> Css.Style
scrollbarWidth sw =
    Css.property "scrollbar-width" <|
        case sw of
            Auto ->
                "auto"

            Thin ->
                "thin"

            None ->
                "none"


scrollbarColor : Color -> Color -> Css.Style
scrollbarColor scrollColor backgroudColor =
    Css.property "scrollbar-color" <| Color.toCssString scrollColor ++ " " ++ Color.toCssString backgroudColor
