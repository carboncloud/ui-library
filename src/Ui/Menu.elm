module Ui.Menu exposing (Model, Msg, update, view)

import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events exposing (onClick)
import Json.Decode as JD
import Ui.Button
import Ui.Css.Palette as Palette
import Ui.Icon as Icon exposing (Icon)
import Ui.Shadow as Shadow exposing (shadow)
import Ui.Text as Text
import Ui.TextStyle as TextStyle
import Extra.Styled exposing (whenJust)


type alias Option msg =
    { name : String
    , icon : Maybe Icon
    , action : msg
    }


type alias Model =
    { open : Bool }


type Msg
    = Open
    | Close


update : Msg -> Model -> Model
update msg model =
    case msg of
        Open ->
            { model | open = True }

        Close ->
            { model | open = False }


view : { label : String, liftMsg : Msg -> msg, options : List (Option msg) } -> Model -> Html msg
view { label, liftMsg, options } { open } =
    Html.div [ onClick <| liftMsg Open ] <|
        Ui.Button.iconButton
            [ css
                [ if open then
                    Css.backgroundColor Palette.gray300

                  else
                    Css.backgroundColor Css.transparent
                ]
            ]
            { onClick = Just <| liftMsg Open
            , icon = Icon.more
            , tooltip = "entry-actions"
            }
            :: (if open then
                    [ Html.div
                        [ css
                            [ Css.position Css.absolute
                            , Css.width (Css.pct 100)
                            , Css.height (Css.pct 100)
                            , Css.left (Css.px 0)
                            , Css.top (Css.px 0)
                            , Css.cursor Css.default
                            ]
                        , onClickNoPropagation <| liftMsg Close
                        ]
                        []
                    , Html.div
                        [ Role.dialog
                        , Aria.label label
                        , Attributes.css <|
                            [ Css.position Css.absolute
                            , Css.borderRadius (Css.px 5)
                            , Css.backgroundColor Palette.white
                            , Css.overflow Css.hidden
                            , shadow Shadow.Small
                            , Css.minWidth (Css.px 150)
                            , Css.cursor Css.pointer
                            , Css.padding2 (Css.px 10) Css.zero
                            ]
                        ]
                      <|
                        List.map optionView options
                    ]

                else
                    []
               )


onClickNoPropagation : msg -> Attribute msg
onClickNoPropagation onClick =
    Events.custom "click" (JD.succeed { message = onClick, stopPropagation = True, preventDefault = True })


optionView : Option msg -> Html msg
optionView { name, icon } =
    Html.div
        [ css
            [ Css.padding2 (Css.px 10) (Css.px 15)
            , Css.displayFlex
            , Css.textAlign Css.left
            , Css.hover [ Css.backgroundColor Palette.gray200 ]
            ]
        ]
        [ whenJust icon Icon.view24x24
        , Text.customView [ css [ Css.flex (Css.num 1), Css.margin2 Css.auto (Css.px 15) ] ] TextStyle.body name
        ]
