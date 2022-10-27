module Ui.Font exposing
    ( Font(..)
    ,  FontFamily
       -- Keep opaque

    ,  FontSize
       -- Keep opaque

    ,  FontWeight
       -- Keep opaque

    , bodyFamily
    , bold
    , fontColorToCssStyle
    , large
    , light
    , normal
    , primary
    , regular
    , small
    , toCssStyle
    , toElementAttribute, black, disabled, white, semiBold, xxl, xl
    )

import Color exposing (Color)
import Css exposing (Rem, rem)
import Element
import Element.Font as Font
import Html.Attributes
import Rpx exposing (rpx)
import Ui.Color



{-
   This module defines the data structure of a `Font`
   and defines the available font properties.

   Type constructors for the font properties are kept
   opque intentionally to prevent the typography to
   become inconsistent.


   # Types

    @docs Font, Family, Size, Weight
-}


type Font
    = Font
        { family : FontFamily
        , size : FontSize
        , weight : FontWeight
        , color : FontColor
        }


{-| Represents a font family
-}
type FontFamily
    = FontFamily String


{-| Represents a font size
-}
type FontSize
    = FontSize Rem


{-| Represents a font weight
-}
type FontWeight
    = FontWeight Int


{-| Represents a font color
-}
type FontColor
    = FontColor Color


unwrapFontFamily : FontFamily -> String
unwrapFontFamily (FontFamily x) =
    x


unwrapFontSize : FontSize -> Rem
unwrapFontSize (FontSize x) =
    x


unwrapFontWeight : FontWeight -> Int
unwrapFontWeight (FontWeight x) =
    x

unwrapFontColor : FontColor -> Color
unwrapFontColor (FontColor x) =
    x


fontFamily : Font -> String
fontFamily (Font { family }) =
    unwrapFontFamily family


fontSize : Font -> Rem
fontSize (Font { size }) =
    unwrapFontSize size


fontWeight : Font -> Int
fontWeight (Font { weight }) =
    unwrapFontWeight weight


fontColor : Font -> Color
fontColor (Font { color }) =
    unwrapFontColor  color


primary : FontFamily
primary =
    FontFamily "Poppins"


bodyFamily : FontFamily
bodyFamily =
    FontFamily "Merriweather"


small : FontSize
small =
    FontSize <| rpx 14


normal : FontSize
normal =
    FontSize <| rpx 16


large : FontSize
large =
    FontSize <| rpx 18


xl : FontSize
xl = FontSize <| rpx 43


xxl : FontSize
xxl = FontSize <| rpx 53

light : FontWeight
light =
    FontWeight 300


regular : FontWeight
regular =
    FontWeight 400


semiBold : FontWeight
semiBold =
    FontWeight 600

bold : FontWeight
bold =
    FontWeight 700

white : FontColor
white = FontColor <| Ui.Color.fromHex "#FCFCFC"

black : FontColor
black = FontColor <| Ui.Color.fromHex "#161616"

disabled : FontColor
disabled = FontColor <| Ui.Color.fromHex "#757575"


toCssStyle : Font -> List Css.Style
toCssStyle font =
    List.map (\f -> f font) [ fontSizeToCssStyle, fontFamilyToCssStyle, fontWeightToCssStyle, fontColorToCssStyle ]


fontFamilyToCssStyle : Font -> Css.Style
fontFamilyToCssStyle =
    Css.fontFamilies << List.singleton << Css.qt << fontFamily


fontSizeToCssStyle : Font -> Css.Style
fontSizeToCssStyle =
    Css.fontSize << fontSize


fontWeightToCssStyle : Font -> Css.Style
fontWeightToCssStyle =
    Css.fontWeight << Css.int << fontWeight


fontColorToCssStyle : Font -> Css.Style
fontColorToCssStyle =
    Css.color << Ui.Color.toCssColor << fontColor



-- Element


toElementAttribute : Font -> List (Element.Attribute msg)
toElementAttribute typography =
    List.map (\f -> f typography) [ fontFamilyToElementAttribute, fontSizeToElementAttribute, fontWeightToElementAttribute, fontColorToElementAttribute ]


fontFamilyToElementAttribute : Font -> Element.Attribute msg
fontFamilyToElementAttribute =
    Font.family << List.singleton << Font.typeface << fontFamily


fontSizeToElementAttribute : Font -> Element.Attribute msg
fontSizeToElementAttribute =
    Element.htmlAttribute << (\x -> Html.Attributes.style "font-size" (String.fromFloat x.numericValue ++ "rem")) << fontSize


fontWeightToElementAttribute : Font -> Element.Attribute msg
fontWeightToElementAttribute =
    Element.htmlAttribute << Html.Attributes.style "font-weight" << String.fromInt << fontWeight


fontColorToElementAttribute : Font -> Element.Attribute msg
fontColorToElementAttribute =
    Font.color << Ui.Color.toElementColor << fontColor
