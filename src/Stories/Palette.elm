module Stories.Palette exposing (..)

import Color.Internal exposing (toHexString)
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color
import Ui.Palette as Palette
import Ui.Text
import Ui.Typography


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
            [ Ui.Text.customView [ Attributes.css [ Css.margin2 (Css.px 5) (Css.px 10) ] ] Ui.Typography.label <| toHexString color ]
        , Ui.Text.customView [ Attributes.css [ Css.margin2 (Css.px 5) (Css.px 10) ] ] Ui.Typography.label name
        ]


colorSwatchGroup : List (Styled.Html msg) -> Styled.Html msg
colorSwatchGroup =
    Styled.div
        [ Attributes.css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]


toneGroup : String -> List ( Css.Color, Int ) -> List (Styled.Html msg)
toneGroup name tones =
    [ Ui.Text.view Ui.Typography.h2 name
    , Styled.div
        [ Attributes.css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            ]
        ]
      <|
        List.map (\( color, tone ) -> colorSwatch (String.fromInt tone) color) tones
    ]


view : Html msg
view =
    Styled.toUnstyled <|
        Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "35px", Css.backgroundColor <| Color.toCssColor Palette.white ] ]
            [ colorSwatchGroup <|
                toneGroup "Primary"
                    [ ( Color.toCssColor Palette.primary050, 50 )
                    , ( Color.toCssColor Palette.primary500, 500 )
                    , ( Color.toCssColor Palette.primary600, 600 )
                    ]
            , colorSwatchGroup <|
                toneGroup "Secondary"
                    [ ( Color.toCssColor Palette.secondary050, 50 )
                    , ( Color.toCssColor Palette.secondary500, 500 )
                    , ( Color.toCssColor Palette.secondary600, 600 )
                    ]
            , colorSwatchGroup <|
                [ colorSwatch "black" <| Color.toCssColor Palette.black, colorSwatch "white" <| Color.toCssColor Palette.white ]
                    ++ toneGroup "Grey"
                        [ ( Color.toCssColor Palette.grey050, 50 )
                        , ( Color.toCssColor Palette.grey100, 100 )
                        , ( Color.toCssColor Palette.grey200, 200 )
                        , ( Color.toCssColor Palette.grey300, 300 )
                        , ( Color.toCssColor Palette.grey500, 500 )
                        , ( Color.toCssColor Palette.grey800, 800 )
                        ]
            , colorSwatchGroup
                (toneGroup "Status"
                    [ ( Color.toCssColor Palette.warn050, 50 )
                    , ( Color.toCssColor Palette.warn500, 500 )
                    , ( Color.toCssColor Palette.warn600, 600 )
                    ]
                    ++ [ colorSwatch "success" <| Color.toCssColor Palette.success
                       , colorSwatch "focus" <| Color.toCssColor Palette.focus
                       ]
                )
            ]
