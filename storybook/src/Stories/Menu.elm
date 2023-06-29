module Stories.Menu exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Stories.Table exposing (Msg(..))
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Button as Button
import Ui.Css.Palette as Palette
import Ui.Icon as Icon
import Ui.Menu as Menu


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls = Storybook.Controls.none
        , view = \_ -> view
        , init = { open = False }
        , update = update
        }


type alias Model =
    { open : Bool }


type Msg
    = GotMenuMsg Menu.Msg
    | Noop


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotMenuMsg menuMsg ->
            let
                menuModel =
                    Menu.update menuMsg model
            in
            menuModel

        Noop ->
            model


view : Model -> Html Msg
view model =
    Styled.toUnstyled <|
        Menu.view
            { liftMsg = GotMenuMsg
            , label = "test-menu"
            , interactiveComponent =
                \open onClick ->
                    Button.iconButton
                        [ css
                            [ if open then
                                Css.backgroundColor Palette.gray300

                              else
                                Css.backgroundColor Css.transparent
                            ]
                        ]
                        { onClick = Just onClick
                        , icon = Icon.more
                        , tooltip = "entry-actions"
                        }
            , options =
                [ { name = "Delete"
                  , icon = Just Icon.delete
                  , action = Noop
                  }
                , { name = "Copy"
                  , icon = Just Icon.copy
                  , action = Noop
                  }
                ]
            }
            model
