module Ui.RadioButton exposing (Direction(..), customView, view)

import Accessibility.Styled as A11y exposing (Html)
import Css exposing (disabled)
import Css.Transitions as Transitions
import Html exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Color as Color
import Ui.Font as Font exposing (Font(..))
import Ui.Palette as Palette
import Ui.Text as Text
import Ui.Font as Font


type Direction
    = Horizontal
    | Vertical


view :
    { onChange : a -> msg
    , options : List { optionLabel : String, value : a, disabled : Bool }
    , label : String
    , selected : Maybe a
    , direction : Direction
    }
    -> Html msg
view =
    customView []


customView :
    List (Attribute Never)
    ->
        { onChange : a -> msg
        , options : List { optionLabel : String, value : a, disabled : Bool }
        , label : String
        , selected : Maybe a
        , direction : Direction
        }
    -> Html msg
customView attrs config =
    let
        itemView : Int -> { optionLabel : String, value : a, disabled : Bool } -> Html msg
        itemView idx { optionLabel, value, disabled } =
            let
                itemId =
                    dasherize <| String.toLower config.label ++ "-" ++ String.fromInt idx ++ "-" ++ optionLabel

                isSelected =
                    config.selected == Just value

                baseStyle =
                    [ Css.property "display" "grid"
                    , Css.property "place-items" "center"
                    , Css.property "appearance" "none"
                    , Css.property "-webkit-appearance" "none"
                    , Css.width (rpx 20)
                    , Css.height (rpx 20)
                    , Css.borderRadius (rpx 10)
                    , Css.margin Css.zero
                    , Css.before
                        [ Css.property "content" "\"\""
                        , Css.height (rpx 12)
                        , Css.width (rpx 12)
                        , Css.borderRadius (rpx 6)
                        , if isSelected then
                            Css.transform (Css.scale 1)

                          else
                            Css.transform (Css.scale 0)
                        , Transitions.transition [ Transitions.transform3 150 0 Transitions.easeInOut ]
                        ]
                    ]
            in
            A11y.label
                [ Attributes.css
                    [ Css.displayFlex ]
                ]
                [ A11y.radio itemId
                    optionLabel
                    isSelected
                  <|
                    (if disabled then
                        []

                     else
                        [ Events.onClick <| config.onChange value ]
                    )
                        ++ [ Attributes.css <|
                                baseStyle
                                    ++ (if disabled then
                                            [ Css.border3 (Css.px 2) Css.solid <| Color.toCssColor Palette.disabled
                                            , Css.cursor Css.notAllowed
                                            , Css.before
                                                [ Css.boxShadow4 Css.inset (rpx 10) (rpx 10) <| Color.toCssColor Palette.disabled ]
                                            ]

                                        else
                                            [ Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]
                                            , Css.focus
                                                [ Css.outline3 (Css.px 2) Css.solid <| Color.toCssColor Palette.focus
                                                ]
                                            , Css.border3 (Css.px 2) Css.solid <| Color.toCssColor Palette.grey800
                                            , Css.cursor Css.pointer
                                            , Css.before
                                                [ Css.boxShadow4 Css.inset (rpx 10) (rpx 10) <| Color.toCssColor Palette.grey800 ]
                                            ]
                                       )
                           ]
                , Text.customView
                    [ Attributes.css <|
                        Css.margin2 Css.auto (Css.px 10)
                            :: (if disabled then
                                    [ Css.color <| Color.toCssColor Palette.disabled ]

                                else
                                    []
                               )
                    ]
                    (Font { family = Font.primary, weight = Font.regular, size = Font.small, color = Font.black })
                    optionLabel
                ]
    in
    A11y.fieldset
        (Attributes.css
            [ Css.displayFlex
            , Css.property "gap" "20px"
            , case config.direction of
                Horizontal ->
                    Css.flexDirection Css.row

                Vertical ->
                    Css.flexDirection Css.column
            ]
            :: List.map Attributes.fromUnstyled attrs
        )
    <|
        A11y.legend [ Attributes.css [ Css.margin2 (rpx 20) Css.zero ] ] [ Text.view Font.label config.label ]
            :: List.indexedMap itemView config.options
