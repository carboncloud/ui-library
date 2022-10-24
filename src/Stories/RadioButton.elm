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
                    , fallback = "Radio button"
                    }
        , view = view
        , init = init
        , update = update
        }


type alias Controls =
    { label : String
    }


type alias Model =
    { selectedOption : Maybe RadioOption }


init =
    { selectedOption = Just Item1 }


type Msg
    = UserSelectedOption RadioOption


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedOption option ->
            { model | selectedOption = Just option }


type RadioOption
    = Item1
    | Item2
    | Item3


view : Controls -> Model -> Html Msg
view controls model =
    toUnstyled <|
        Ui.RadioButton.static
            { onChange = UserSelectedOption
            , label = controls.label
            , items = Dict.fromList [ ( "item 1", Item1 ), ( "item 2", Item2 ) ]
            , selected = model.selectedOption
            }
