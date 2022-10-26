module Ui.Css exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Rpx exposing (rpx)
import Ui.Color as Color exposing (Color)
import Ui.Typography as Typography exposing (Typography(..))



------------------------
-- Typography
------------------------


fromTypography : Typography -> List Css.Style
fromTypography typography =
    List.map (\f -> f typography) [ fontSize, fontFamily, fontWeight ]


fontFamily : Typography -> Css.Style
fontFamily =
    Css.fontFamilies << List.singleton << Css.qt << Typography.family


fontSize : Typography -> Css.Style
fontSize =
    Css.fontSize << rpx << Typography.size


fontWeight : Typography -> Css.Style
fontWeight =
    Css.fontWeight << Css.int << Typography.weight


color : Typography -> Css.Style
color =
    Css.color << fromColor << Typography.color



------------------------
-- Color
------------------------


fromColor : Color -> Css.Color
fromColor =
    (\{ red, green, blue, alpha } ->
        Css.rgba
            (round <| red * 255)
            (round <| green * 255)
            (round <| blue * 255)
            alpha
    )
        << Color.toRgba
