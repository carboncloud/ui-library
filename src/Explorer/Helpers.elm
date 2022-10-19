module Explorer.Helpers exposing (colorSwatch, colorSwatchGroup, toneGroup, story, simpleStory)

import Border
import Color.Internal
import Css exposing (Color)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import UIExplorer exposing (Model)
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)


simpleStory : String -> Styled.Html b -> ( String, Model a b {} -> Html b, {}) 
simpleStory name view = (name, \_ -> toUnstyled view, {} )

story : String -> (Model a b {} -> Styled.Html b) -> ( String, Model a b {} -> Html b, {}) 
story name view = (name, toUnstyled << view, {} )

colorSwatch : String -> Color -> Styled.Html msg
colorSwatch name color =
    Styled.div []
        [ Styled.div
            [ Attributes.css
                [ Css.backgroundColor color
                , Css.height (Css.px 100)
                , Css.width (Css.px 100)
                , Css.margin2 (Css.px 10) Css.zero
                ]
            ]
            []
        , Styled.h5 [ Attributes.css [ Css.margin2 (Css.px 5) Css.zero ] ]
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
            ]
        ]

toneGroup : String -> List (Color, Int) -> List (Styled.Html msg)
toneGroup name = List.map (\(color, tone) -> colorSwatch (name ++ "-" ++ String.fromInt tone) color)
