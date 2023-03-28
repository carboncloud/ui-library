module Ui.Dialog exposing (..)

import Accessibility.Styled as Html exposing (Html)
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Css
import Html.Styled.Attributes as Attributes exposing (css)
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Button as Button
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette as Palette
import Ui.Shadow as Shadow exposing (shadow)
import Ui.Text as Text
import Ui.TextStyle as TextStyle


view : { title : String, content : Html msg, onClose : msg, actionButtons : List (Html msg) } -> Html msg
view { title, content, onClose, actionButtons } =
    widget (dasherize title)
        [ css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.transform (Css.translate2 (Css.pct -50) (Css.pct -50))
            , Css.minWidth (Css.px 300)
            , Css.maxWidth (Css.px 900)
            , Css.left (Css.pct 50)
            , Css.padding (rpx 25)
            ]
        ]
        ([ Button.iconButton
            [ css [ Css.alignSelf Css.end, Css.margin (Css.px -10)] ]
            { onClick = Just onClose
            , tooltip = "close"
            , icon = Icon.close
            }
         , Html.div
            [ css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Css.margin4 Css.zero (Css.px 25) (Css.px 25) (Css.px 25) 
                ]
            ]
            [ Text.customView [ css [ Css.margin Css.auto, Css.textAlign Css.center] ] TextStyle.heading4 title
            , content ]
        , Html.div [ css [ Css.alignSelf Css.end, Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "10px"] ] <| actionButtons
         ]
        )


widget : String -> List (Html.Attribute Never) -> List (Html msg) -> Html msg
widget labelledBy attrs content =
    Html.div
        (attrs
            ++ [ Role.dialog
               , Aria.labelledBy labelledBy
               , Attributes.css <|
                    [ Css.position Css.fixed
                    , Css.borderRadius (Css.px 10)
                    , shadow Shadow.Large
                    ]
               ]
        )
        content
