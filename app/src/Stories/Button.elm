module Stories.Button exposing (..)

import Css exposing (displayFlex, flex)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (toUnstyled)
import Svg.Styled.Attributes exposing (css)
import Ui.Button exposing (ButtonColor(..), ButtonEmphasis(..))
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette as Palette


main : Component () Msg
main =
    Storybook.Component.stateless
        { controls =
            Storybook.Controls.new Controls
                |> Storybook.Controls.withString
                    { name = "label"
                    , fallback = "Create post"
                    }
                |> Storybook.Controls.withEnum
                    { name = "type"
                    , options = [ ( "Raised", High ), ( "Ghost", Mid ), ( "Flat", Low ) ]
                    , fallback = High
                    }
                |> Storybook.Controls.withEnum
                    { name = "color"
                    , options = [ ( "Primary", Primary ), ( "Secondary", Secondary ), ( "Warn", Warn ), ( "Neutral", Neutral ) ]
                    , fallback = Primary
                    }
        , view = view
        }


type alias Controls =
    { label : String
    , emphasis : ButtonEmphasis
    , color : ButtonColor
    }


type Msg
    = UserClickedButton
    | Noop


view : Controls -> Html Msg
view controls =
    toUnstyled <|
        Styled.div [ css [ displayFlex, Css.property "gap" "20px" ] ] <|
            List.map (Styled.div [] << List.singleton) <|
                [ Ui.Button.view
                    { emphasis = controls.emphasis
                    , color = controls.color
                    , onClick = Just UserClickedButton
                    }
                    (Ui.Button.Text controls.label)
                , Ui.Button.customView
                    [ Css.color <| toCssColor Palette.secondary500
                    ]
                    []
                    { emphasis = controls.emphasis
                    , color = Ui.Button.Primary
                    , onClick = Just UserClickedButton
                    }
                    (Ui.Button.Text "TEST CUSTOM")
                , Ui.Button.view
                    { emphasis = controls.emphasis
                    , color = controls.color
                    , onClick = Nothing
                    }
                    (Ui.Button.Text controls.label)
                , Ui.Button.view
                    { emphasis = controls.emphasis
                    , color = controls.color
                    , onClick = Just UserClickedButton
                    }
                    (Ui.Button.TextWithLeftIcon controls.label Icon.edit)
                , Ui.Button.view
                    { emphasis = controls.emphasis
                    , color = controls.color
                    , onClick = Just UserClickedButton
                    }
                    (Ui.Button.TextWithRightIcon controls.label Icon.edit)
                , Ui.Button.iconButton []
                    { icon = Icon.newWindow
                    , tooltip = "Open in new window"
                    , onClick = Just UserClickedButton
                    }
                ]
