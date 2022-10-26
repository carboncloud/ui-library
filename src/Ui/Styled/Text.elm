module Ui.Styled.Text exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Ui.Typography exposing (Typography)
import Ui.Css as Css

view : Typography -> String -> Styled.Html msg
view typography = customView [] typography

customView : List (Styled.Attribute msg) -> Typography -> String -> Styled.Html msg
customView attrs typography s = Styled.span ((Attributes.css <| Css.fromTypography typography) :: attrs) [ Styled.text s ]
