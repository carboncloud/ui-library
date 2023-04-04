module Ui.Text exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Rpx exposing (rpx)
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.TextStyle as TextStyle exposing (TextStyle(..))



{-

   # Text

    This module defines components that has to do with our text.

    Text is defined as:
        _Text is the art of arranging letters and text in a way that makes the copy legible, clear, and visually appealing to the reader._

    ## Styled components
    @docs view, customView, styledParagraph, styledCustomParagraph

    ## Element component
    @docs elementText

-}


{-| Returns a text view
This is preferred over `customView` when no custom styling is needed
-}
view : TextStyle -> String -> Styled.Html msg
view font =
    customView [] font


{-| Returns a custom text view
-}
customView : List (Styled.Attribute msg) -> TextStyle -> String -> Styled.Html msg
customView attrs font s =
    Styled.span (attrs ++ [ Attributes.css <| toCssStyle font ]) [ Styled.text s ]


paragraph : String -> Styled.Html msg
paragraph =
    styledCustomParagraph [] TextStyle.body


styledParagraph : TextStyle -> String -> Styled.Html msg
styledParagraph font =
    styledCustomParagraph [] font


styledCustomParagraph : List (Styled.Attribute msg) -> TextStyle -> String -> Styled.Html msg
styledCustomParagraph attrs font s =
    Styled.p
        ((Attributes.css <|
            Css.lineHeight (Css.num 1.5)
                :: Css.margin2 (rpx 15) Css.zero
                :: toCssStyle font
         )
            :: attrs
        )
        [ Styled.text s ]
