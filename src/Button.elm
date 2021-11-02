module Button exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes as StyledAttrs

type ButtonAttribute msg = ButtonAttribute Css.Style


type alias ColorPalette =
    { primary : Css.Color
    }


colorPalette : ColorPalette
colorPalette =
    { primary = Css.rgb 0 255 0
    }

color : (ColorPalette-> Css.Color) -> ColorPalette -> ButtonAttribute msg
color f = ButtonAttribute << Css.backgroundColor <<  f


type ButtonContent = Text String | TextAndIcon String String

toAttr : List (ButtonAttribute msg) -> Styled.Attribute msg
toAttr = StyledAttrs.css << List.map (\(ButtonAttribute attr) -> attr)

button : List (ButtonAttribute msg) -> ButtonContent -> Styled.Html msg
button buttonAttrs buttonContent = 
    Styled.button [ toAttr buttonAttrs ] <| case buttonContent of
        Text s ->
            [ Styled.text s ]
        TextAndIcon s i ->
            [ Styled.img [ StyledAttrs.href i ] [], Styled.text s ]

raised : List (ButtonAttribute msg) -> ButtonContent -> Styled.Html msg
raised attrs content =
    button (color .primary colorPalette :: attrs) content
