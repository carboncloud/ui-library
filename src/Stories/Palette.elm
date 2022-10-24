module Stories.Palette exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color exposing (Color)
import Ui.Css.Palette exposing (palette)
import Color.Internal exposing (toHexString)


main : Component () msg
main =
    Storybook.Component.stateless
        { controls = Storybook.Controls.none
        , view = \_ -> view
        }


colorSwatch : String -> Css.Color -> Styled.Html msg
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
        , Styled.h6 [] [ Styled.text <| toHexString color ]
        ]


colorSwatchGroup : List (Styled.Html msg) -> Styled.Html msg
colorSwatchGroup =
    Styled.div
        [ Attributes.css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            ]
        ]


toneGroup : String -> List ( Css.Color, Int ) -> List (Styled.Html msg)
toneGroup name =
    List.map (\( color, tone ) -> colorSwatch (name ++ "-" ++ String.fromInt tone) color)


view : Html msg
view =
    Styled.toUnstyled <|
        Styled.div []
            [ colorSwatchGroup <|
                toneGroup "primary"
                    [ ( palette.primary050, 50 )
                    , ( palette.primary500, 500 )
                    , ( palette.primary600, 600 )
                    ]
            , colorSwatchGroup <|
                toneGroup "secondary"
                    [ ( palette.secondary050, 50 )
                    , ( palette.secondary500, 500 )
                    , ( palette.secondary600, 600 )
                    ]
            , colorSwatchGroup <|
                [ colorSwatch "black" palette.black, colorSwatch "white" palette.white ]
                    ++ toneGroup "grey"
                        [ ( palette.grey050, 50 )
                        , ( palette.grey100, 100 )
                        , ( palette.grey200, 200 )
                        , ( palette.grey300, 300 )
                        , ( palette.grey500, 500 )
                        , ( palette.grey800, 800 )
                        ]
            , colorSwatchGroup
                (toneGroup "warn"
                    [ ( palette.warn050, 50 )
                    , ( palette.warn500, 500 )
                    , ( palette.warn600, 600 )
                    ]
                    ++ [ colorSwatch "success" palette.success
                       , colorSwatch "focus" palette.focus
                       ]
                )
            ]
