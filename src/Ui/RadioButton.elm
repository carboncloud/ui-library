module Ui.RadioButton exposing (custom, dynamic, static)

import Accessibility.Styled as A11y exposing (Html)
import Css
import Css.Transitions as Transitions
import Dict exposing (Dict)
import Html exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Css.Palette exposing (palette)


{-
    This is useful when the options need to be created dynamically.
    E.g. options are fetched from a remote location
-}
dynamic :
    { onChange : a -> msg
    , items : List ( String, a )
    , label : String
    , selected : Maybe a
    }
    -> Html msg
dynamic =
    custom []


{-
    This is a fallback for when you need to ahve complete control of the component.
    Avoid using this if not necessary.
-}
custom :
    List (Attribute Never)
    ->
        { onChange : a -> msg
        , items : List ( String, a )
        , label : String
        , selected : Maybe a
        }
    -> Html msg
custom attrs config =
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
                , A11y.span [ Attributes.css [ Css.marginLeft (Css.px 5), Css.fontWeight Css.bold ] ] [ A11y.text itemLabel ]
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



{-
   This is the most type safe version and should be used when possible
-}
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
