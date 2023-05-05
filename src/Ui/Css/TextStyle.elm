module Ui.Css.TextStyle exposing
    ( body
    , heading1
    , heading2
    , heading3
    , heading4
    , toCssStyle
    )

{-|

    ## Interprets TextStyle as a Styled element


    ### Interpreters
    @docs heading1, heading2, heading3, heading4, body

    ### Converters
    @docs toCssStyle

-}

import Css
import Rpx exposing (rpx)
import Ui.Color
import Ui.TextStyle as TextStyle exposing (TextStyle(..), fontWeight)


{-| -}
heading1 : List Css.Style
heading1 =
    toCssStyle TextStyle.heading1


{-| -}
heading2 : List Css.Style
heading2 =
    toCssStyle TextStyle.heading2


{-| -}
heading3 : List Css.Style
heading3 =
    toCssStyle TextStyle.heading3


{-| -}
heading4 : List Css.Style
heading4 =
    toCssStyle TextStyle.heading4


{-| -}
body : List Css.Style
body =
    toCssStyle TextStyle.body


{-|

    Interprets a font as a Css Style

-}
toCssStyle : TextStyle -> List Css.Style
toCssStyle font =
    List.map (\f -> f font) [ fontSizeToCssStyle, fontFamilyToCssStyle, fontWeightToCssStyle, fontColorToCssStyle, lineHeightToCssStyle ]


fontFamilyToCssStyle : TextStyle -> Css.Style
fontFamilyToCssStyle (TextStyle { family }) =
    Css.fontFamilies <| List.map Css.qt family


fontSizeToCssStyle : TextStyle -> Css.Style
fontSizeToCssStyle (TextStyle { size }) =
    Css.fontSize <| rpx <| toFloat size


fontWeightToCssStyle : TextStyle -> Css.Style
fontWeightToCssStyle (TextStyle { weight }) =
    Css.fontWeight <| Css.int <| fontWeight weight


fontColorToCssStyle : TextStyle -> Css.Style
fontColorToCssStyle (TextStyle { color }) =
    Css.color <| Ui.Color.toCssColor color


lineHeightToCssStyle : TextStyle -> Css.Style
lineHeightToCssStyle (TextStyle { lineHeight }) =
    Css.lineHeight (Css.num lineHeight)
