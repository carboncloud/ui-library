module Ui.Typography exposing (..)

import Css
import Element exposing (Element)
import Element.Font as Font
import Html.Attributes
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Rpx exposing (rpx)
import Ui.Font as Font exposing (Font(..))



{-

   # Typography

    This module defines components that has to do with our typography.

    Typography is defined as:
        _Typography is the art of arranging letters and text in a way that makes the copy legible, clear, and visually appealing to the reader._

    ## Styled components
    @docs styledText, styledCustomText, styledParagraph, styledCustomParagraph

    ## Element component
    @docs elementText

-}


{-| Returns a text view
This is preferred over `styledCustomText` when no custom style is needed
-}
styledText : Font -> String -> Styled.Html msg
styledText font =
    styledCustomText [] font


{-| Returns a custom text view
-}
styledCustomText : List (Styled.Attribute msg) -> Font -> String -> Styled.Html msg
styledCustomText attrs font s =
    Styled.span ((Attributes.css <| Font.toCssStyle font) :: attrs) [ Styled.text s ]


styledParagraph : Font -> String -> Styled.Html msg
styledParagraph font =
    styledCustomParagraph [] font


styledCustomParagraph : List (Styled.Attribute msg) -> Font -> String -> Styled.Html msg
styledCustomParagraph attrs font s =
    Styled.p
        ((Attributes.css <|
            Css.lineHeight (Css.num 1.5)
                :: Css.margin2 (rpx 15) Css.zero
                :: Font.toCssStyle font
         )
            :: attrs
        )
        [ Styled.text s ]



-- Element


elementText : Font -> String -> Element msg
elementText font =
    Element.el
        ((Element.htmlAttribute <|
            Html.Attributes.style "word-wrap" "break-word"
         )
            :: (Element.htmlAttribute <| Html.Attributes.style "white-space" "pre-wrap")
            :: Element.width Element.fill
            :: Font.toElementAttribute font
        )
        << Element.text
