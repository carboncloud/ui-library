module Ui.Element.Typography exposing (..)

import Element exposing (Element)
import Element.Font as Font
import Html.Attributes
import Rpx exposing (rpx)
import Ui.Element.Palette as Palette
import Ui.Typography as Typography exposing (Typography)


text : Typography -> String -> Element msg
text typography =
    Element.el
        ((Element.htmlAttribute <|
            Html.Attributes.style "word-wrap" "break-word"
         )
            :: (Element.htmlAttribute <| Html.Attributes.style "white-space" "pre-wrap")
            :: Element.width Element.fill
            :: fromTypography typography
        )
        << Element.text


fromTypography : Typography -> List (Element.Attribute msg)
fromTypography typography =
    List.map (\f -> f typography) [ fontSize, fontFamily, fontWeight ]


fontFamily : Typography -> Element.Attribute msg
fontFamily =
    Font.family << List.singleton << Font.typeface << Typography.family


fontSize : Typography -> Element.Attribute msg
fontSize =
    Element.htmlAttribute << (\x -> Html.Attributes.style "font-size" (String.fromFloat (x / 16) ++ "rem")) << Typography.size


fontWeight : Typography -> Element.Attribute msg
fontWeight =
    Element.htmlAttribute << Html.Attributes.style "font-weight" << String.fromInt << Typography.weight


color : Typography -> Element.Attribute msg
color =
    Font.color << Palette.fromColor << Typography.color
