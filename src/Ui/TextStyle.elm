module Ui.TextStyle exposing
    ( FontWeight(..)
    , TextStyle(..)
    , body
    , bodySmall
    , fontWeight
    , heading1
    , heading2
    , heading3
    , heading4
    , label
    , sansSerifFamilies
    )

{-|


# TextStyle

This module defines a `TextStyle`
and the available font properties.


## Types

    @docs TextStyle

    ## Body

    @docs bodySmall, body

    ## Heading

    @docs heading1, heading2, heading3, heading4

    ## Others
    @docs label

    ## Font families
    @docs sansSerifFamilies

    ## Font weights
    @docs FontWeight, fontWeight

-}


{-| -}
type TextStyle
    = TextStyle
        { family : List String
        , size : Int
        , weight : FontWeight
        , lineHeight : Float
        }


{-| -}
sansSerifFamilies : List String
sansSerifFamilies =
    [ "Poppins", "system-ui", "sans-serif" ]


{-| -}
bodySmall : TextStyle
bodySmall =
    TextStyle
        { family = sansSerifFamilies
        , size = 14
        , weight = Normal
        , lineHeight = 1.2
        }


{-| -}
body : TextStyle
body =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = Normal
        , lineHeight = 1.5
        }


{-| -}
label : TextStyle
label =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = SemiBold
        , lineHeight = 1.2
        }


{-| -}
heading1 : TextStyle
heading1 =
    TextStyle
        { family = sansSerifFamilies
        , size = 72
        , weight = SemiBold
        , lineHeight = 1.2
        }


{-| -}
heading2 : TextStyle
heading2 =
    TextStyle
        { family = sansSerifFamilies
        , size = 48
        , weight = SemiBold
        , lineHeight = 1.2
        }


{-| -}
heading3 : TextStyle
heading3 =
    TextStyle
        { family = sansSerifFamilies
        , size = 32
        , weight = SemiBold
        , lineHeight = 1.2
        }


{-| -}
heading4 : TextStyle
heading4 =
    TextStyle
        { family = sansSerifFamilies
        , size = 16
        , weight = SemiBold
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
