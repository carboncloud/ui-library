module Stories.Button exposing (..)

import Html exposing (Html)
import Html.Styled as Styled
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (toUnstyled)
import Ui.Button exposing (ButtonEmphasis(..))


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
        , view = view
        }


type alias Controls =
    { label : String
    , emphasis : ButtonEmphasis
    }


type Msg
    = UserClickedButton


view : Controls -> Html Msg
view controls =
    toUnstyled <|
        Styled.div []
            [ Ui.Button.view
                { emphasis = controls.emphasis
                , color = Ui.Button.Primary
                , onClick = Just UserClickedButton
                }
                (Ui.Button.Text controls.label)
            , Ui.Button.view
                { emphasis = controls.emphasis
                , color = Ui.Button.Primary
                , onClick = Nothing
                }
                (Ui.Button.Text controls.label)
            , Ui.Button.view
                { emphasis = Mid
                , color = Ui.Button.Primary
                , onClick = Just UserClickedButton
                }
                (Ui.Button.Text controls.label)
            , Ui.Button.view
                { emphasis = Mid
                , color = Ui.Button.Primary
                , onClick = Nothing
                }
                (Ui.Button.Text controls.label)
            , Ui.Button.view
                { emphasis = Low
                , color = Ui.Button.Primary
                , onClick = Just UserClickedButton
                }
                (Ui.Button.Text controls.label)
            , Ui.Button.view
                { emphasis = Low
                , color = Ui.Button.Primary
                , onClick = Nothing
                }
                (Ui.Button.Text controls.label)
            ]
