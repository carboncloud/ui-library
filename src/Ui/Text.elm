module Ui.Text exposing
    ( customParagraph
    , customView
    , paragraph
    , view
    )

{-|


# Text

    This module defines components that has to do with our text.

    ## Styled components
    @docs view, customView, paragraph, customParagraph

-}

import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.TextStyle as TextStyle exposing (TextStyle(..))


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


{-| -}
paragraph : String -> Styled.Html msg
paragraph =
    styledCustomParagraph [] TextStyle.body


{-| -}
customParagraph : TextStyle -> String -> Styled.Html msg
customParagraph font =
    styledCustomParagraph [] font


{-| -}
styledCustomParagraph : List (Styled.Attribute msg) -> TextStyle -> String -> Styled.Html msg
styledCustomParagraph attrs font s =
    Styled.p
        ((Attributes.css <|
            [ Css.margin2 (Css.px 15) Css.zero, Css.color Css.currentColor ]
                ++ toCssStyle font
         )
            :: attrs
        )
        [ Styled.text s ]
