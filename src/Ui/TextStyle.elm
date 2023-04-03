module Ui.TextStyle exposing
    ( TextStyle(..)
    , body
    , bodySmall
    , heading1
    , heading2
    , heading3
    , heading4
    , label, sansSerifFamilies, primaryColor, primaryWhiteColor, fontWeight, FontWeight(..)
    )

import Color exposing (Color)
import Ui.Color as Color
import Ui.Palette as Palette


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
        { family : List String
        , size : Int
        , weight : FontWeight
        , color : Color
        , lineHeight : Float
        }

primaryColor : Color
primaryColor = Palette.grey900

primaryWhiteColor : Color
primaryWhiteColor = Color.fromHex "#FCFCFC"

sansSerifFamilies : List String
sansSerifFamilies = ["Poppins", "system-ui", "sans-serif"]

bodySmall : TextStyle
bodySmall =
    TextStyle
        { family = sansSerifFamilies
        , size = 14
        , weight = Normal
        , color = primaryColor
        , lineHeight = 1.2
        }


body : TextStyle
body =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = Normal
        , color = primaryColor
        , lineHeight = 1.2
        }


label : TextStyle
label =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = SemiBold
        , lineHeight = 1.2
        , color = primaryColor
        }


heading1 : TextStyle
heading1 =
    TextStyle
        { family = sansSerifFamilies
        , size = 72
        , weight = SemiBold
        , color = primaryColor
        , lineHeight = 1.2
        }


heading2 : TextStyle
heading2 =
    TextStyle
        { family = sansSerifFamilies
        , size = 48
        , weight = SemiBold
        , color = primaryColor
        , lineHeight = 1.2
        }


heading3 : TextStyle
heading3 =
    TextStyle
        { family = sansSerifFamilies
        , size = 32
        , weight = SemiBold
        , color = primaryColor
        , lineHeight = 1.2
        }


heading4 : TextStyle
heading4 =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = SemiBold
        , color = primaryColor
        , lineHeight = 2
        }


{-| Represents a font weight
-}


type FontWeight
    = Thin
    | ExtraLight
    | Light
    | Normal
    | Medium
    | SemiBold
    | Bold
    | ExtraBold


{-| Return the weight of a font
-}
fontWeight : FontWeight -> Int
fontWeight weight =
    case weight of
        Thin ->
            100

        ExtraLight ->
            200

        Light ->
            300

        Normal ->
            400

        Medium ->
            500

        SemiBold ->
            600

        Bold ->
            700

        ExtraBold ->
            800
