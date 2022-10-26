module Stories.Palette exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color exposing (Color)
import Ui.Palette exposing (palette)
import Color.Internal exposing (toHexString)
import Ui.Css


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
        Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "35px", Css.backgroundColor <| Ui.Css.fromColor palette.white] ]
            [ colorSwatchGroup <|
                toneGroup "primary"
                    [ ( Ui.Css.fromColor palette.primary050, 50 )
                    , ( Ui.Css.fromColor palette.primary500, 500 )
                    , ( Ui.Css.fromColor palette.primary600, 600 )
                    ]
            , colorSwatchGroup <|
                toneGroup "secondary"
                    [ ( Ui.Css.fromColor palette.secondary050, 50 )
                    , ( Ui.Css.fromColor palette.secondary500, 500 )
                    , ( Ui.Css.fromColor palette.secondary600, 600 )
                    ]
            , colorSwatchGroup <|
                [ colorSwatch "black" <| Ui.Css.fromColor palette.black, colorSwatch "white" <| Ui.Css.fromColor palette.white ]
                    ++ toneGroup "grey"
                        [ ( Ui.Css.fromColor palette.grey050, 50 )
                        , ( Ui.Css.fromColor palette.grey100, 100 )
                        , ( Ui.Css.fromColor palette.grey200, 200 )
                        , ( Ui.Css.fromColor palette.grey300, 300 )
                        , ( Ui.Css.fromColor palette.grey500, 500 )
                        , ( Ui.Css.fromColor palette.grey800, 800 )
                        ]
            , colorSwatchGroup
                (toneGroup "warn"
                    [ ( Ui.Css.fromColor palette.warn050, 50 )
                    , ( Ui.Css.fromColor palette.warn500, 500 )
                    , ( Ui.Css.fromColor palette.warn600, 600 )
                    ]
                    ++ [ colorSwatch "success" <| Ui.Css.fromColor palette.success
                       , colorSwatch "focus" <| Ui.Css.fromColor palette.focus
                       ]
                )
            ]
