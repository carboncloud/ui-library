module Stories.Dialog exposing (..)

import Html exposing (Html)
import Html.Styled as Styled
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Button as Button
import Ui.Dialog as Dialog
import Ui.Text as Text
import Ui.TextStyle as TextStyle


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls = Storybook.Controls.none
        , view = \_ -> view
        , init = { isOpen = False }
        , update = update
        }


type alias Model =
    { isOpen : Bool }


type Msg
    = CloseDialog
    | OpenDialog


update : Msg -> Model -> Model
update msg model =
    case msg of
        CloseDialog ->
            { model | isOpen = False }

        OpenDialog ->
            { model | isOpen = True }


view : Model -> Html Msg
view { isOpen } =
    Styled.toUnstyled <|
        if isOpen then
            Dialog.view
                { title = "My Dialog"
                , labelId = "my-dialog"
                , content = Text.view TextStyle.body "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                , onClose = CloseDialog
                , actionButtons =
                    [ ( { onClick = Just CloseDialog, emphasis = Button.Low, color = Button.Primary }, Button.Text "Cancel" )
                    , ( { onClick = Just CloseDialog, emphasis = Button.High, color = Button.Primary }, Button.Text "Submit" )
                    ]
                }

        else
            Button.view { onClick = Just OpenDialog, emphasis = Button.High, color = Button.Primary } (Button.Text "Open")
