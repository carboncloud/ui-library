module Ui.RadioButton exposing (customView, static, view)

import Accessibility.Styled as A11y exposing (Html)
import Css
import Css.Transitions as Transitions
import Dict exposing (Dict)
import Html exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import Stories.Button exposing (Msg)
import String.Extra exposing (dasherize)
import Ui.Css
import Ui.Palette as Palette
import Ui.Styled.Text as Text
import Ui.Typography as Typography exposing (Typography(..))


view :
    { onChange : a -> msg
    , items : List ( String, a )
    , label : String
    , selected : Maybe a
    }
    -> Html msg
view =
    customView []


customView :
    List (Attribute Never)
    ->
        { onChange : a -> msg
        , items : List ( String, a )
        , label : String
        , selected : Maybe a
        }
    -> Html msg
customView attrs config =
    let
        itemView : Int -> ( String, a ) -> Html msg
        itemView idx ( itemLabel, value ) =
            let
                itemId =
                    dasherize <| String.toLower config.label ++ "-" ++ String.fromInt idx ++ "-" ++ itemLabel

                isSelected =
                    config.selected == Just value
            in
            A11y.label [ Attributes.css [ Css.displayFlex ] ]
                [ A11y.radio itemId
                    itemLabel
                    isSelected
                    [ Events.onClick <| config.onChange value
                    , Attributes.css
                        [ Css.property "display" "grid"
                        , Css.property "place-items" "center"
                        , Css.property "appearance" "none"
                        , Css.property "-webkit-appearance" "none"
                        , Css.width (rpx 20)
                        , Css.height (rpx 20)
                        , Css.borderRadius (rpx 10)
                        , Css.hover [ Css.backgroundColor <| Ui.Css.fromColor Palette.primary050 ]
                        , Css.focus
                            [ Css.outline3 (Css.px 2) Css.solid <| Ui.Css.fromColor Palette.focus
                            , Css.outlineOffset (Css.px 2)
                            ]
                        , Css.border3 (Css.px 2) Css.solid <| Ui.Css.fromColor Palette.primary500
                        , Css.cursor Css.pointer
                        , Css.before
                            [ Css.property "content" "\"\""
                            , Css.height (rpx 10)
                            , Css.width (rpx 10)
                            , Css.borderRadius (rpx 5)
                            , Css.boxShadow4 Css.inset (rpx 10) (rpx 10) <| Ui.Css.fromColor Palette.primary500
                            , if isSelected then
                                Css.transform (Css.scale 1)

                              else
                                Css.transform (Css.scale 0)
                            , Transitions.transition [ Transitions.transform3 150 0 Transitions.easeInOut ]
                            ]
                        ]
                    ]
                , optionLabel itemLabel
                ]
    in
    A11y.fieldset
        (Attributes.css
            [ Css.displayFlex
            , Css.property "gap" "20px"
            ]
            :: List.map Attributes.fromUnstyled attrs
        )
    <|
        A11y.legend [] [ A11y.text config.label ]
            :: List.indexedMap itemView config.items


static :
    { onChange : a -> msg
    , items : Dict String a
    , label : String
    , selected : Maybe a
    }
    -> Html msg
static { onChange, items, label, selected } =
    view
        { onChange = onChange
        , items = Dict.toList items
        , label = label
        , selected = selected
        }


optionLabel : String -> Html msg
optionLabel =
    Text.customView
        [ Attributes.css
            [ Css.margin2 Css.auto (Css.px 5)
            , Css.fontWeight Css.bold
            ]
        ]
        (Typography
            { family = Typography.poppins
            , size = Typography.normal
            , weight = Typography.regular
            , color = Palette.white
            }
        )
