module Ui.Input exposing (search)

{-| an input is an element used to collect user data within a web form.
It allows users to enter information such as text, numbers, or other data types, which can then be submitted to a server for processing.

@docs search

-}

import Accessibility.Styled as Styled
import Accessibility.Styled.Aria as Aria
import Css
import Extra.Styled as Styled
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events
import Rpx exposing (rpx)
import Ui.Button
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette


inputTextBaseStyle : Attribute msg
inputTextBaseStyle =
    css
        [ Css.padding2 (Css.px 4) (Css.px 5)
        , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.gray200)
        , Css.displayFlex
        , Css.pseudoClass "focus-within" [ Css.outline3 (Css.px 2) Css.solid (toCssColor Ui.Palette.primary500) ]
        ]


{-|

    Renders a search input field.

    Takes the following configuration:
    - `value`:      The value of the search field
    - `onInput`:    A message that takes the new value of the input
    - `onClear`:    The message that should be emitted when a user presses the clear button
    - `onSearch:    Maybe a message that should be emitted when the user presses the search button

-}
search :
    List (Styled.Attribute Never)
    ->
        { value : String
        , onInput : String -> msg
        , onClear : msg
        , onSearch : Maybe msg
        }
    -> Styled.Html msg
search attrs { value, onInput, onClear, onSearch } =
    Styled.div ([ inputTextBaseStyle, css [ Css.borderRadius (rpx 20) ] ] ++ attrs) <|
        [ Ui.Button.iconButton [ css [ Css.cursor Css.default ] ]
            { tooltip = "search"
            , onClick = onSearch
            , icon = Icon.search
            }
        , Styled.inputText value
            [ Html.Styled.Events.onInput onInput
            , Aria.label "search-text-input-field"
            , css [ Css.border (Css.px 0), Css.flexGrow (Css.num 1), Css.marginRight (Css.px 7), Css.outline Css.none ]
            ]
        , Styled.when (value /= "") <|
            Ui.Button.iconButton []
                { tooltip = "clear"
                , onClick = Just onClear
                , icon = Icon.close
                }
        ]
