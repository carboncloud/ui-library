module Ui.DataAttributes exposing (asStyledAttribute)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Json.Encode as JE
import String.Extra exposing (dasherize)

asStyledAttribute : (String, JE.Value) -> Attribute msg
asStyledAttribute (suffix, value) = Attributes.property ("data-" ++ dasherize suffix) value
