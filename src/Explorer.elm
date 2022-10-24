module Explorer exposing (main)

import Ui.Button exposing (ButtonColor(..))
import Ui.Palette
import Color.Internal
import Css
import Dict exposing (Dict)
import Explorer.Helpers exposing (colorSwatch, colorSwatchGroup, story, toneGroup)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes as Attributes
import Ui.RadioButton
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )
import Explorer.Helpers exposing (simpleStory)


config =
    { customModel = { radiobutton1Selected = "value2" }
    , customHeader =
        Just
            { title = "Design System"
            , logo =
                UIExplorer.logoFromHtml <|
                    toUnstyled <|
                        Styled.img [ Attributes.src "/assets/logo.svg", Attributes.css [ Css.marginLeft (Css.px 10) ] ] []
            , titleColor = Just <| Color.Internal.toHexString Ui.Palette.primary500
            , bgColor = Just "#FFFFFF"
            }
    , update = update
    , subscriptions =
        \_ -> Sub.none
    , viewEnhancer = \_ stories -> stories
    , menuViewEnhancer = \_ v -> v
    , onModeChanged = Nothing
    }


type Msg
    = Noop
    | RadiobuttonChanged String


type alias Model =
    { radiobutton1Selected : String }


update : Msg -> UIExplorer.Model Model Msg {} -> ( UIExplorer.Model Model Msg {}, Cmd Msg )
update msg ({ customModel } as model) =
    Tuple.mapFirst (\newCustomModel -> { model | customModel = newCustomModel }) <|
        case msg of
            Noop ->
                ( customModel, Cmd.none )

            RadiobuttonChanged value ->
                ( { customModel | radiobutton1Selected = value }, Cmd.none )


main : UIExplorerProgram Model Msg {}
main =
    explore
        config
        [ storiesOf
            "Buttons"
            [ simpleStory "Button" <|
                Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "25px" ] ]
                    [ Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                        [ Ui.Button.raised Primary Noop <| Ui.Button.Text "Primary"
                        , Ui.Button.raised Secondary Noop <| Ui.Button.Text "Secondary"
                        , Ui.Button.raised Warn Noop <| Ui.Button.Text "Warn"
                        ]
                    , Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                        [ Ui.Button.ghost Primary Noop <| Ui.Button.Text "Primary"
                        , Ui.Button.ghost Secondary Noop <| Ui.Button.Text "Secondary"
                        , Ui.Button.ghost Warn Noop <| Ui.Button.Text "Warn"
                        ]
                    , Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                        [ Ui.Button.flat Primary Noop <| Ui.Button.Text "Primary"
                        , Ui.Button.flat Secondary Noop <| Ui.Button.Text "Secondary"
                        , Ui.Button.flat Warn Noop <| Ui.Button.Text "Warn"
                        ]
                    ]
            ]
        , storiesOf
            "Color"
            [ simpleStory "Primary" <|
                colorSwatchGroup <|
                    toneGroup "primary"
                        [ ( Ui.Palette.primary050, 50 )
                        , ( Ui.Palette.primary500, 500 )
                        , ( Ui.Palette.primary600, 600 )
                        ]
            , simpleStory "Secondary" <|
                colorSwatchGroup <|
                    toneGroup "secondary"
                        [ ( Ui.Palette.secondary050, 50 )
                        , ( Ui.Palette.secondary500, 500 )
                        , ( Ui.Palette.secondary600, 600 )
                        ]
            , simpleStory "Greys" <|
                colorSwatchGroup <|
                    [ colorSwatch "black" Ui.Palette.black, colorSwatch "white" Ui.Palette.white ]
                        ++ toneGroup "grey"
                            [ ( Ui.Palette.grey050, 50 )
                            , ( Ui.Palette.grey100, 100 )
                            , ( Ui.Palette.grey200, 200 )
                            , ( Ui.Palette.grey300, 300 )
                            , ( Ui.Palette.grey500, 500 )
                            , ( Ui.Palette.grey800, 800 )
                            ]
            , simpleStory "Status" <|
                colorSwatchGroup
                    (toneGroup "warn"
                        [ ( Ui.Palette.warn050, 50 )
                        , ( Ui.Palette.warn500, 500 )
                        , ( Ui.Palette.warn600, 600 )
                        ]
                        ++ [ colorSwatch "success" Ui.Palette.success
                           , colorSwatch "focus" Ui.Palette.focus
                           ]
                    )
            ]
        , storiesOf
            "RadioButton"
            [ story "Horizontal" <|
                \model -> Ui.RadioButton.static
                    { onChange = RadiobuttonChanged
                    , items = Dict.fromList [ ( "label1", "value1" ), ( "label2", "value2" ) ]
                    , selected = Just model.customModel.radiobutton1Selected
                    , label = "Horizontal radiobuttons"
                    }
            ]
        ]
