module Explorer.Helpers exposing (colorSwatch, colorSwatchGroup, toneGroup)

import Border
import Color.Internal
import Css exposing (Color)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes


colorSwatch : String -> Color -> Styled.Html msg
colorSwatch name color =
    Styled.div []
        [ Styled.div
            [ Attributes.css
                [ Css.backgroundColor color
                , Css.height (Css.px 100)
                , Css.width (Css.px 100)
                , Border.rounded
                ]
            ]
            []
        , Styled.h5 []
            [ Styled.text name
            ]
        , Styled.h6 [] [ Styled.text <| Color.Internal.toHexString color ]
        ]


colorSwatchGroup : List (Styled.Html msg) -> Styled.Html msg
colorSwatchGroup =
    Styled.div
        [ Attributes.css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            , Css.property "gap" "20px"
            ]
        ]

toneGroup : String -> List (Color, Int) -> List (Styled.Html msg)
toneGroup name = List.map (\(color, tone) -> colorSwatch (name ++ "-" ++ String.fromInt tone) color)
