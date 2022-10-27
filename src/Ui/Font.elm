module Ui.Font exposing
    ( Font(..)
    , FontFamily
    , FontSize
    , FontWeight
    , body
    , bodyFamily
    , bodyLarge
    , bodySmall
    , bold
    , disabledColor
    , fontColorToCssStyle
    , fontFamilyToCssStyle
    , fontSizeToCssStyle
    , fontWeightToCssStyle
    , heading1
    , heading2
    , heading3
    , heading4
    , label
    , large
    , light
    , normal
    , primaryColor
    , primaryFamily
    , regular
    , semiBold
    , small
    , toCssStyle
    , toElementAttribute
    , white
    , xl
    , xxl, fontFamilyToElementAttribute, fontSizeToElementAttribute, fontWeightToElementAttribute, fontColorToElementAttribute
    )

import Color exposing (Color)
import Css exposing (Rem, rem)
import Element
import Element.Font as Font
import Html.Attributes
import Rpx exposing (rpx)
import Ui.Color



{-
   # Font

   This module defines a `Font`
   and the available font properties.

   Type constructors for the font properties are kept
   opque intentionally to prevent the typography to
   become inconsistent.


   ## Types

    @docs Font, Family, Size, Weight

    ## Body

    @docs bodySmall, body, bodyLarge

    ## Heading

    @docs heading1, heading2, heading3, heading4

    ## Converters

    ### Css
    @docs toCssStyle, fontFamilyToCssStyle, fontSizeToCssStyle, fontWeightToCssStyle, fontColorToCssStyle

    ### Element
    @docs toElementAttribute, fontFamilyToElementAttribute, fontSizeToElementAttribute, fontWeightToElementAttribute, fontColorToElementAttribute
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


unwrapFontFamily : FontFamily -> String
unwrapFontFamily (FontFamily x) =
    x


{-| Represents a font size
-}
type FontSize
    = FontSize Rem


unwrapFontSize : FontSize -> Rem
unwrapFontSize (FontSize x) =
    x


{-| Represents a font weight
-}
type FontWeight
    = FontWeight Int


unwrapFontWeight : FontWeight -> Int
unwrapFontWeight (FontWeight x) =
    x


{-| Represents a font color
-}
type FontColor
    = FontColor Color


unwrapFontColor : FontColor -> Color
unwrapFontColor (FontColor x) =
    x


{-|

    Gives back the font family of a specific `Font`

-}
fontFamily : Font -> String
fontFamily (Font { family }) =
    unwrapFontFamily family


{-| Return the size of a font
-}
fontSize : Font -> Rem
fontSize (Font { size }) =
    unwrapFontSize size


{-| Return the weight of a font
-}
fontWeight : Font -> Int
fontWeight (Font { weight }) =
    unwrapFontWeight weight


{-| Return the color of a font
-}
fontColor : Font -> Color
fontColor (Font { color }) =
    unwrapFontColor color


{-| The primary font family.

    Typically used for headings, buttons, labels ect.

-}
primaryFamily : FontFamily
primaryFamily =
    FontFamily "Poppins"


{-| The body font family.

    Typically used for body text.

-}
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
xl =
    FontSize <| rpx 43


xxl : FontSize
xxl =
    FontSize <| rpx 53


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
white =
    FontColor <| Ui.Color.fromHex "#FCFCFC"


{-| The primary font color.

    Should be used for things of importance.

-}
primaryColor : FontColor
primaryColor =
    FontColor <| Ui.Color.fromHex "#161616"


{-| The disabled font color.

    Should be used to indicate that no actions are available.

-}
disabledColor : FontColor
disabledColor =
    FontColor <| Ui.Color.fromHex "#757575"


bodySmall : Font
bodySmall =
    Font
        { family = bodyFamily
        , size = small
        , weight = regular
        , color = primaryColor
        }


body : Font
body =
    Font
        { family = bodyFamily
        , size = normal
        , weight = regular
        , color = primaryColor
        }


bodyLarge : Font
bodyLarge =
    Font
        { family = bodyFamily
        , size = large
        , weight = regular
        , color = primaryColor
        }


label : Font
label =
    Font
        { family = primaryFamily
        , size = large
        , weight = semiBold
        , color = primaryColor
        }


heading1 : Font
heading1 =
    Font
        { family = primaryFamily
        , size = xxl
        , weight = semiBold
        , color = primaryColor
        }


heading2 : Font
heading2 =
    Font
        { family = primaryFamily
        , size = xl
        , weight = semiBold
        , color = primaryColor
        }


heading3 : Font
heading3 =
    Font
        { family = primaryFamily
        , size = large
        , weight = semiBold
        , color = primaryColor
        }


heading4 : Font
heading4 =
    Font
        { family = primaryFamily
        , size = normal
        , weight = semiBold
        , color = primaryColor
        }

{-|
    Converts a font to its Css Style representation
-}
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
