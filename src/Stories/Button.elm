module Stories.Button exposing (..)

import Html exposing (Html)
import Storybook.Component exposing (Component)
import Storybook.Controls
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
    Ui.Button.view
        { emphasis = controls.emphasis
        , color = Ui.Button.Primary
        , onClick = UserClickedButton
        }
        (Ui.Button.Text controls.label)
