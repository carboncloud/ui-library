module Ui.Typography exposing (..)

import Css
import Element exposing (Element)
import Ui.TextStyle exposing (TextStyle)
import Html.Attributes
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Rpx exposing (rpx)
import Ui.TextStyle as TextStyle exposing (TextStyle(..))



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
    This is preferred over `styledCustomText` when no custom styling is needed
-}
styledText : TextStyle -> String -> Styled.Html msg
styledText font =
    styledCustomText [] font


{-| Returns a custom text view
-}
styledCustomText : List (Styled.Attribute msg) -> TextStyle -> String -> Styled.Html msg
styledCustomText attrs font s =
    Styled.span (attrs ++ [Attributes.css <| TextStyle.toCssStyle font]) [ Styled.text s ]


styledParagraph : TextStyle -> String -> Styled.Html msg
styledParagraph font =
    styledCustomParagraph [] font


styledCustomParagraph : List (Styled.Attribute msg) -> TextStyle -> String -> Styled.Html msg
styledCustomParagraph attrs font s =
    Styled.p
        ((Attributes.css <|
            Css.lineHeight (Css.num 1.5)
                :: Css.margin2 (rpx 15) Css.zero
                :: TextStyle.toCssStyle font
         )
            :: attrs
        )
        [ Styled.text s ]



-- Element


elementText : TextStyle -> String -> Element msg
elementText font =
    Element.el
        ((Element.htmlAttribute <|
            Html.Attributes.style "word-wrap" "break-word"
         )
            :: (Element.htmlAttribute <| Html.Attributes.style "white-space" "pre-wrap")
            :: Element.width Element.fill
            :: TextStyle.toElementAttribute font
        )
        << Element.text
