module Explorer exposing (main)

import Button exposing (ButtonColor(..))
import Color
import Color.Internal
import Css
import Dict exposing (Dict)
import Explorer.Helpers exposing (colorSwatch, colorSwatchGroup, story, toneGroup)
import Html.Styled as Styled exposing (toUnstyled)
import Html.Styled.Attributes as Attributes
import RadioButton
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
            , titleColor = Just <| Color.Internal.toHexString Color.primary500
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
                        [ Button.raised Primary Noop <| Button.Text "Primary"
                        , Button.raised Secondary Noop <| Button.Text "Secondary"
                        , Button.raised Warn Noop <| Button.Text "Warn"
                        ]
                    , Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                        [ Button.ghost Primary Noop <| Button.Text "Primary"
                        , Button.ghost Secondary Noop <| Button.Text "Secondary"
                        , Button.ghost Warn Noop <| Button.Text "Warn"
                        ]
                    , Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "20px" ] ]
                        [ Button.flat Primary Noop <| Button.Text "Primary"
                        , Button.flat Secondary Noop <| Button.Text "Secondary"
                        , Button.flat Warn Noop <| Button.Text "Warn"
                        ]
                    ]
            ]
        , storiesOf
            "Color"
            [ simpleStory "Primary" <|
                colorSwatchGroup <|
                    toneGroup "primary"
                        [ ( Color.primary050, 50 )
                        , ( Color.primary500, 500 )
                        , ( Color.primary600, 600 )
                        ]
            , simpleStory "Secondary" <|
                colorSwatchGroup <|
                    toneGroup "secondary"
                        [ ( Color.secondary050, 50 )
                        , ( Color.secondary500, 500 )
                        , ( Color.secondary600, 600 )
                        ]
            , simpleStory "Greys" <|
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
            , simpleStory "Status" <|
                colorSwatchGroup
                    (toneGroup "warn"
                        [ ( Color.warn050, 50 )
                        , ( Color.warn500, 500 )
                        , ( Color.warn600, 600 )
                        ]
                        ++ [ colorSwatch "success" Color.success
                           , colorSwatch "focus" Color.focus
                           ]
                    )
            ]
        , storiesOf
            "RadioButton"
            [ story "Horizontal" <|
                \model -> RadioButton.static
                    { onChange = RadiobuttonChanged
                    , items = Dict.fromList [ ( "label1", "value1" ), ( "label2", "value2" ) ]
                    , selected = Just model.customModel.radiobutton1Selected
                    , label = "Horizontal radiobuttons"
                    }
            ]
        ]
