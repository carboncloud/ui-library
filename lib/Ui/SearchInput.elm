module Ui.SearchInput exposing (..)

import Accessibility.Styled as Styled
import Css
import Html.Styled.Attributes exposing (css, property)
import Html.Styled.Events
import Json.Encode as JE
import Ui.Button
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.Shadow
import Rpx exposing (rpx)


inputTextBaseStyle : Styled.Attribute msg
inputTextBaseStyle =
    css
        [ Css.padding4 (Css.px 4) (Css.px 0) (Css.px 4) (Css.px 5)
        , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300)
        , Css.borderRadius (rpx 20)
        , Css.displayFlex
        , Css.pseudoClass "focus-within" [ Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.primary500) ]
        ]


iconStyle =
    css
        [ Css.height (Css.px 30)
        , Css.width (Css.px 30)
        , Css.display Css.inlineBlock
        , Css.margin4 Css.auto (Css.px 10) Css.auto (Css.px 0)
        , Css.fill (toCssColor Ui.Palette.grey800)
        ]


view : { searchLabel : String, value : String, onInput : String -> msg, onClear : msg } -> Styled.Html msg
view { searchLabel, value, onInput, onClear } =
    Styled.div [ inputTextBaseStyle ]
        [ Ui.Button.customView [ iconStyle ]
            { emphasis = Ui.Button.Low
            , onClick = Nothing
            , color = Ui.Button.Primary
            }
            (Ui.Button.Icon { icon = Icon.search, tooltip = "search" })
        , Styled.inputText value
            [ Html.Styled.Events.onInput onInput
            , property "autocomplete" (JE.string searchLabel)
            , css [ Css.border (Css.px 0), Css.flexGrow (Css.num 1), Css.outline Css.none ]
            ]
        , Ui.Button.customView [ iconStyle ]
            { emphasis = Ui.Button.Low
            , onClick = Just onClear
            , color = Ui.Button.Primary
            }
            (Ui.Button.Icon { icon = Icon.close, tooltip = "clear" })
        ]
