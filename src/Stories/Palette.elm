module Stories.Palette exposing (..)

import Color.Internal exposing (toHexString)
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color exposing (Color)
import Ui.Css
import Ui.Palette as Palette


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
                , Css.height (Css.px 150)
                , Css.width (Css.px 150)
                , Css.margin2 (Css.px 10) Css.zero
                , Css.padding (Css.px 10)
                , Css.fontWeight Css.bold
                , Css.displayFlex
                , Css.flexDirection Css.column
                , Css.justifyContent Css.end
                ]
            ]
            [ Styled.text <| toHexString color ]
        , Styled.h5 [ Attributes.css [ Css.fontSize (Css.px 14), Css.margin2 (Css.px 5) (Css.px 10) ] ]
            [ Styled.text name ]
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
        Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "35px", Css.backgroundColor <| Ui.Css.fromColor Palette.white ] ]
            [ colorSwatchGroup <|
                toneGroup "primary"
                    [ ( Ui.Css.fromColor Palette.primary050, 50 )
                    , ( Ui.Css.fromColor Palette.primary500, 500 )
                    , ( Ui.Css.fromColor Palette.primary600, 600 )
                    ]
            , colorSwatchGroup <|
                toneGroup "secondary"
                    [ ( Ui.Css.fromColor Palette.secondary050, 50 )
                    , ( Ui.Css.fromColor Palette.secondary500, 500 )
                    , ( Ui.Css.fromColor Palette.secondary600, 600 )
                    ]
            , colorSwatchGroup <|
                [ colorSwatch "black" <| Ui.Css.fromColor Palette.black, colorSwatch "white" <| Ui.Css.fromColor Palette.white ]
                    ++ toneGroup "grey"
                        [ ( Ui.Css.fromColor Palette.grey050, 50 )
                        , ( Ui.Css.fromColor Palette.grey100, 100 )
                        , ( Ui.Css.fromColor Palette.grey200, 200 )
                        , ( Ui.Css.fromColor Palette.grey300, 300 )
                        , ( Ui.Css.fromColor Palette.grey500, 500 )
                        , ( Ui.Css.fromColor Palette.grey800, 800 )
                        ]
            , colorSwatchGroup
                (toneGroup "warn"
                    [ ( Ui.Css.fromColor Palette.warn050, 50 )
                    , ( Ui.Css.fromColor Palette.warn500, 500 )
                    , ( Ui.Css.fromColor Palette.warn600, 600 )
                    ]
                    ++ [ colorSwatch "success" <| Ui.Css.fromColor Palette.success
                       , colorSwatch "focus" <| Ui.Css.fromColor Palette.focus
                       ]
                )
            ]
