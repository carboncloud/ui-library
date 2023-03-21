module Ui.TextStyle exposing
    ( TextStyle(..)
    , body
    , bodyLarge
    , bodySmall
    , fontColorToCssStyle
    , fontColorToElementAttribute
    , fontFamilyToCssStyle
    , fontFamilyToElementAttribute
    , fontSizeToCssStyle
    , fontSizeToElementAttribute
    , fontWeightToCssStyle
    , fontWeightToElementAttribute
    , heading1
    , heading2
    , heading3
    , heading4
    , heading5
    , label
    , toCssStyle
    , toElementAttribute
    )

import Css
import Element
import Element.Font as Font
import Html.Attributes
import Ui.Color
import Ui.Internal.FontFamily as FontFamily exposing (FontFamily, fontFamily)
import Ui.Internal.FontSize as FontSize exposing (FontSize, fontSize)
import Ui.Internal.FontWeight as FontWeight exposing (FontWeight, fontWeight)
import Ui.Internal.TextColor as TextColor exposing (TextColor, textColor)



{-
   # TextStyle

   This module defines a `TextStyle`
   and the available font properties.

   Type constructors for the font properties are kept
   opque intentionally to prevent the typography to
   become inconsistent.


   ## Types

    @docs TextStyle

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


type TextStyle
    = TextStyle
        { family : FontFamily
        , size : FontSize
        , weight : FontWeight
        , color : TextColor
        }


bodySmall : TextStyle
bodySmall =
    TextStyle
        { family = FontFamily.Body
        , size = FontSize.Small
        , weight = FontWeight.Regular
        , color = TextColor.Primary
        }


body : TextStyle
body =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Normal
        , weight = FontWeight.Regular
        , color = TextColor.Primary
        }


bodyLarge : TextStyle
bodyLarge =
    TextStyle
        { family = FontFamily.Body
        , size = FontSize.Normal
        , weight = FontWeight.Regular
        , color = TextColor.Primary
        }


label : TextStyle
label =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Normal
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


heading1 : TextStyle
heading1 =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.XXL
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


heading2 : TextStyle
heading2 =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.XL
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


heading3 : TextStyle
heading3 =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Large
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


heading4 : TextStyle
heading4 =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Normal
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


heading5 : TextStyle
heading5 =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Small
        , weight = FontWeight.SemiBold
        , color = TextColor.Primary
        }


{-|

    Interprets a font as a Css Style

-}
toCssStyle : TextStyle -> List Css.Style
toCssStyle font =
    List.map (\f -> f font) [ fontSizeToCssStyle, fontFamilyToCssStyle, fontWeightToCssStyle, fontColorToCssStyle ]


fontFamilyToCssStyle : TextStyle -> Css.Style
fontFamilyToCssStyle (TextStyle { family }) =
    Css.fontFamilies <| List.singleton <| Css.qt <| fontFamily family


fontSizeToCssStyle : TextStyle -> Css.Style
fontSizeToCssStyle (TextStyle { size }) =
    Css.fontSize <| fontSize size


fontWeightToCssStyle : TextStyle -> Css.Style
fontWeightToCssStyle (TextStyle { weight }) =
    Css.fontWeight <| Css.int <| fontWeight weight


fontColorToCssStyle : TextStyle -> Css.Style
fontColorToCssStyle (TextStyle { color }) =
    Css.color << Ui.Color.toCssColor <| textColor color


{-|

    Interprets a `TextStyle` as an Element Attribute

-}
toElementAttribute : TextStyle -> List (Element.Attribute msg)
toElementAttribute typography =
    List.map (\f -> f typography) [ fontFamilyToElementAttribute, fontSizeToElementAttribute, fontWeightToElementAttribute, fontColorToElementAttribute ]


fontFamilyToElementAttribute : TextStyle -> Element.Attribute msg
fontFamilyToElementAttribute (TextStyle { family }) =
    Font.family <| List.singleton <| Font.typeface <| fontFamily family


fontSizeToElementAttribute : TextStyle -> Element.Attribute msg
fontSizeToElementAttribute (TextStyle { size }) =
    Element.htmlAttribute <| (\x -> Html.Attributes.style "font-size" (String.fromFloat x.numericValue ++ "rem")) <| fontSize size


fontWeightToElementAttribute : TextStyle -> Element.Attribute msg
fontWeightToElementAttribute (TextStyle { weight }) =
    Element.htmlAttribute <| Html.Attributes.style "font-weight" <| String.fromInt <| fontWeight weight


fontColorToElementAttribute : TextStyle -> Element.Attribute msg
fontColorToElementAttribute (TextStyle { color }) =
    Font.color <| Ui.Color.toElementColor <| textColor color
