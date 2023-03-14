module Ui.SearchInput exposing (..)

import Accessibility.Styled as Styled
import Css
import Html.Styled.Attributes exposing (css, property)
import Html.Styled.Events
import Json.Encode as JE
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.Shadow


inputTextBaseStyle : Styled.Attribute msg
inputTextBaseStyle =
    css
        [ Css.padding2 (Css.px 7) (Css.px 15)
        , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey500)
        , Css.borderRadius (Css.px 2)
        , Css.displayFlex
        , Css.pseudoClass "focus-within" [ Css.outline3 (Css.px 1) Css.solid (toCssColor Ui.Palette.primary500), Ui.Shadow.focus ]
        ]


iconStyle =
    css
        [ Css.height (Css.px 16)
        , Css.display Css.inlineBlock
        , Css.margin4 Css.auto (Css.px 10) Css.auto (Css.px 0)
        ]


view : { searchLabel : String, value : String, onInput : String -> msg } -> Styled.Html msg
view { searchLabel, value, onInput } =
    Styled.div [ inputTextBaseStyle ]
        [ Styled.span [ iconStyle ] [ Icon.view Icon.search ]
        , Styled.inputText value [ Html.Styled.Events.onInput onInput, property "autocomplete" (JE.string searchLabel), css [ Css.border (Css.px 0), Css.outline Css.none ] ]
        ]
