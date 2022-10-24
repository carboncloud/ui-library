module Ui.RadioButton exposing (..)

import Accessibility.Styled as Html exposing (Html)
import Ui.Css.Palette exposing (palette)
import Css
import Css.Transitions as Transitions
import Dict exposing (Dict)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)


dynamic :
    { onChange : a -> msg
    , items : List ( String, a )
    , label : String
    , selected : Maybe a
    }
    -> Html msg
dynamic config =
    let
        itemView : Int -> ( String, a ) -> Html msg
        itemView idx ( itemLabel, value ) =
            let
                itemId =
                    dasherize <| String.toLower config.label ++ "-" ++ String.fromInt idx ++ "-" ++ itemLabel

                isSelected =
                    config.selected == Just value
            in
            Html.label [ Attributes.css [ Css.displayFlex ] ]
                [ Html.radio itemId
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
                        , Css.hover [ Css.backgroundColor palette.primary050 ]
                        , Css.focus
                            [ Css.outline3 (Css.px 2) Css.solid palette.focus
                            , Css.outlineOffset (Css.px 2)
                            ]
                        , Css.border3 (Css.px 2) Css.solid palette.primary500
                        , Css.cursor Css.pointer
                        , Css.before
                            [ Css.property "content" "\"\""
                            , Css.height (rpx 10)
                            , Css.width (rpx 10)
                            , Css.borderRadius (rpx 5)
                            , Css.boxShadow4 Css.inset (rpx 10) (rpx 10) palette.primary500
                            , if isSelected then
                                Css.transform (Css.scale 1)

                              else
                                Css.transform (Css.scale 0)
                            , Transitions.transition [ Transitions.transform3 150 0 Transitions.easeInOut ]
                            ]
                        ]
                    ]
                , Html.span [ Attributes.css [ Css.marginLeft (Css.px 5), Css.fontWeight Css.bold ] ] [ Html.text itemLabel ]
                ]
    in
    Html.fieldset
        [ Attributes.css
            [ Css.displayFlex
            , Css.property "gap" "20px"
            ]
        ]
    <|
        Html.legend [] [ Html.text config.label ]
            :: List.indexedMap itemView config.items


static :
    { onChange : a -> msg
    , items : Dict String a
    , label : String
    , selected : Maybe a
    }
    -> Html msg
static { onChange, items, label, selected } =
    dynamic
        { onChange = onChange
        , items = Dict.toList items
        , label = label
        , selected = selected
        }
