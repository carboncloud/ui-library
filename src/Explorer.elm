module Explorer exposing (main)

import Button exposing (ButtonColor(..))
import Color
import Color.Internal
import Css
import Explorer.Helpers exposing (colorSwatch, colorSwatchGroup, toneGroup)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes as Attributes
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )


config =
    { defaultConfig
        | customHeader =
            Just
                { title = "Substance Design System"
                , logo =
                    UIExplorer.logoFromHtml <|
                        toUnstyled <|
                            Styled.img [ Attributes.src "/assets/logo.svg", Attributes.css [ Css.marginLeft (Css.px 10) ] ] []
                , titleColor = Just <| Color.Internal.toHexString Color.primary500
                , bgColor = Just "#FFFFFF"
                }
    }


type Msg
    = Noop


main : UIExplorerProgram {} Msg {}
main =
    explore
        config
        [ storiesOf
            "Buttons"
            [ ( "Button"
              , \_ ->
                    toUnstyled <|
                        Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                            [ Button.raised [] Noop <| Button.Text "Primary"
                            , Button.raised (Button.color Secondary) Noop <| Button.Text "Secondary"
                            , Button.raised (Button.color Warn) Noop <| Button.Text "Warn"
                            ]
              , {}
              )
            ]
        , storiesOf
            "Color"
            [ ( "Primary"
              , \_ ->
                    toUnstyled <|
                        colorSwatchGroup <|
                            toneGroup "primary"
                                [ ( Color.primary050, 50 )
                                , ( Color.primary500, 500 )
                                , ( Color.primary600, 600 )
                                ]
              , {}
              )
            , ( "Secondary"
              , \_ ->
                    toUnstyled <|
                        colorSwatchGroup <|
                            toneGroup "secondary"
                                [ ( Color.secondary500, 500 )
                                ]
              , {}
              )
            , ( "Greys"
              , \_ ->
                    toUnstyled <|
                        colorSwatchGroup <|
                            [ colorSwatch "black" Color.black, colorSwatch "white" Color.white ]
                                ++ toneGroup "grey"
                                    [ ( Color.grey050, 50 )
                                    , ( Color.grey100, 100 )
                                    , ( Color.grey200, 200 )
                                    , ( Color.grey300, 300 )
                                    , ( Color.grey500, 500 )
                                    , ( Color.grey800, 800 )
                                    ]
              , {}
              )
            , ( "Status"
              , \_ ->
                    toUnstyled <|
                        colorSwatchGroup 
                                [ colorSwatch "warn" Color.warn
                                , colorSwatch "success" Color.success
                                , colorSwatch "focus" Color.focus
                                ]
              , {}
              )
            ]
        ]
