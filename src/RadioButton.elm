module RadioButton exposing (..)

import Accessibility.Styled as Html exposing (Html)
import Color
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
                        , Css.hover [ Css.backgroundColor Color.primary050 ]
                        , Css.focus
                            [ Css.outline3 (Css.px 2) Css.solid Color.focus
                            , Css.outlineOffset (Css.px 1)
                            ]
                        , Css.border3 (Css.px 2) Css.solid Color.primary500
                        , Css.cursor Css.pointer
                        , Css.before
                            [ Css.property "content" "\"\""
                            , Css.height (rpx 10)
                            , Css.width (rpx 10)
                            , Css.borderRadius (rpx 5)
                            , Css.boxShadow4 Css.inset (rpx 10) (rpx 10) Color.primary500
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



{-
   * Labels provided for each element has to be **unique** since its used as the id in combination with the radiogroup label
-}
-- radioButtonsWithCustomContent :
--     { onChange : value -> msg
--     , items : List (OptionConfig value msg)
--     , label : String
--     , selected : Maybe value
--     }
--     -> List (Attribute msg)
--     -> Element msg
-- radioButtonsWithCustomContent { onChange, items, label, selected } attributes =
--     let
--         radio_ idx ({ value, customContentOnSelected } as cfg) =
--             let
--                 isSelected =
--                     MaybeExtra.unwrap False ((==) value) selected
--                 id =
--                     dasherize <| label ++ " " ++ cfg.optionLabel ++ " " ++ String.fromInt idx
--             in
--             Element.column (Element.width Element.fill :: FontStyle.toElementAttributes FontStyle.bodyM)
--                 [ Element.html <|
--                     Html.label [ Html.Attributes.for id, Html.Attributes.class "radio" ] <|
--                         [ Html.span (Html.Attributes.class "radio-input" :: cfg.attributes)
--                             [ Html.input
--                                 [ Html.Attributes.type_ "radio"
--                                 , Html.Attributes.id id
--                                 , Html.Attributes.checked isSelected
--                                 , Html.Attributes.name label
--                                 , Html.Events.onClick <| onChange value
--                                 ]
--                                 []
--                             , Html.span [ Html.Attributes.class "radio-control" ] []
--                             ]
--                         , Html.span
--                             [ Html.Attributes.class <|
--                                 "radio-label"
--                                     ++ (if isSelected then
--                                             " radio-label-checked"
--                                         else
--                                             ""
--                                        )
--                             ]
--                             [ cfg.optionLabelView cfg.optionLabel
--                             ]
--                         ]
--                             ++ (if isSelected then
--                                     [ Element.layoutWith
--                                         { options =
--                                             [ Element.noStaticStyleSheet ]
--                                         }
--                                         [ Element.htmlAttribute <| Html.Attributes.class "custom-content" ]
--                                         customContentOnSelected
--                                     ]
--                                 else
--                                     []
--                                )
--                 ]
--     in
--     Element.column (Element.width Element.fill :: attributes) <| Typography.text [] FontStyle.headingM label :: List.indexedMap radio_ items
