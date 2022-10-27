module Stories.RadioButton exposing (..)

import Dict
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.RadioButton


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls =
            Storybook.Controls.new Controls
                |> Storybook.Controls.withString
                    { name = "label"
                    , fallback = "Choose your option"
                    }
                |> Storybook.Controls.withEnum
                    { name = "direction"
                    , options = [ ( "Horizontal", Ui.RadioButton.Horizontal ), ( "Vertical", Ui.RadioButton.Vertical ) ]
                    , fallback = Ui.RadioButton.Horizontal
                    }
        , view = view
        , init = init
        , update = update
        }


type alias Controls =
    { label : String
    , direction : Ui.RadioButton.Direction
    }


type alias Model =
    { selectedOption : Maybe RadioOption }


init =
    { selectedOption = Just Option3 }


type Msg
    = UserSelectedOption RadioOption


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedOption option ->
            { model | selectedOption = Just option }


type RadioOption
    = Option1
    | Option2
    | Option3


view : Controls -> Model -> Html Msg
view controls model =
    toUnstyled <|
        Ui.RadioButton.view
            { onChange = UserSelectedOption
            , label = controls.label
            , options =
                [ { optionLabel = "Option 1"
                  , value = Option1
                  , disabled = False
                  }
                , { optionLabel = "Option 2"
                  , value = Option2
                  , disabled = False
                  }
                , { optionLabel = "Option 3"
                  , value = Option3
                  , disabled = True
                  }
                ]
            , selected = model.selectedOption
            , direction = controls.direction
            }
