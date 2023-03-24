module Stories.Dialog exposing (..)

import Color.Internal exposing (toHexString)
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Dialog as Dialog
import Ui.Button as Button

main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls = Storybook.Controls.none
        , view = \_ -> view
        , init = { isOpen = False }
        , update = update
        }

type alias Model = { isOpen : Bool}

type Msg = CloseDialog | OpenDialog

update : Msg -> Model -> Model
update msg model = case msg of
    CloseDialog ->
        { model | isOpen = False}
    OpenDialog ->
        { model | isOpen = True }

view : Model -> Html Msg
view { isOpen }=
    Styled.toUnstyled <| 
        if isOpen then
            Dialog.view { title = "My Dialog", content = Styled.text "test", onClose = CloseDialog, actionButtons = []}
        else
            Button.view { onClick = Just OpenDialog, emphasis = Button.High, color = Button.Primary } (Button.Text "Open")
