module Ui.Text exposing (..)

import Html.Attributes
import Element exposing (Element)
import Element.Font as Font
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Ui.Font as Font exposing (Font(..))


-- Styled

view : Font -> String -> Styled.Html msg
view typography =
    customView [] typography


customView : List (Styled.Attribute msg) -> Font -> String -> Styled.Html msg
customView attrs font s =
    Styled.span ((Attributes.css <| Font.toCssStyle font) :: attrs) [ Styled.text s ]



-- Element

text : Font -> String -> Element msg
text font =
    Element.el
        ((Element.htmlAttribute <|
            Html.Attributes.style "word-wrap" "break-word"
         )
            :: (Element.htmlAttribute <| Html.Attributes.style "white-space" "pre-wrap")
            :: Element.width Element.fill
            :: Font.toElementAttribute font
        )
        << Element.text
