module Ui.Input exposing (search)

import Accessibility.Styled as Styled
import Css
import Extra.Styled as Styled
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css, property)
import Html.Styled.Events
import Json.Encode as JE
import Rpx exposing (rpx)
import Ui.Button
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette


inputTextBaseStyle : Attribute msg
inputTextBaseStyle =
    css
        [ Css.padding4 (Css.px 4) (Css.px 5) (Css.px 4) (Css.px 5)
        , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200)
        , Css.displayFlex
        , Css.pseudoClass "focus-within" [ Css.outline3 (Css.px 2) Css.solid (toCssColor Ui.Palette.primary500) ]
        ]


search :
    { searchLabel : String
    , value : String
    , onInput : String -> msg
    , onClear : msg
    }
    -> Styled.Html msg
search { searchLabel, value, onInput, onClear } =
    Styled.div [ inputTextBaseStyle, css [ Css.borderRadius (rpx 20) ] ] <|
        [ Ui.Button.iconButton [ css [ Css.cursor Css.default ] ]
            { tooltip = "search"
            , onClick = Nothing
            , icon = Icon.search
            }
        , Styled.inputText value
            [ Html.Styled.Events.onInput onInput
            , property "autocomplete" (JE.string searchLabel)
            , css [ Css.border (Css.px 0), Css.flexGrow (Css.num 1), Css.marginRight (Css.px 7), Css.outline Css.none ]
            ]
        , Styled.when (value /= "") <|
            Ui.Button.iconButton []
                { tooltip = "clear"
                , onClick = Just onClear
                , icon = Icon.close
                }
        ]
