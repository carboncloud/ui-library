module Ui.Dialog exposing (..)

import Accessibility.Styled as Html exposing (Html)
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Css
import Html.Styled.Attributes as Attributes exposing (css)
import Rpx exposing (rpx)
import Ui.Button as Button exposing (ButtonColor, ButtonEmphasis)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette as Palette
import Ui.Shadow as Shadow exposing (shadow)
import Ui.Text as Text
import Ui.TextStyle as TextStyle


view :
    { title : String
    , labelId : String
    , content : Html msg
    , onClose : msg
    , actionButtons :
        List
            ( { onClick : Maybe msg
              , color : ButtonColor
              , emphasis : ButtonEmphasis
              }
            , Button.ButtonContent
            )
    }
    -> Html msg
view { title, content, onClose, actionButtons, labelId } =
    widget (LabelledBy labelId)
        [ css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.transform (Css.translate2 (Css.pct -50) (Css.pct -50))
            , Css.minWidth (Css.px 300)
            , Css.maxWidth (Css.px 1500)
            , Css.left (Css.pct 50)
            , Css.top (Css.pct 50)
            , Css.padding (rpx 25)
            , Css.zIndex (Css.int 1000)
            ]
        ]
        [ Button.iconButton
            [ css [ Css.alignSelf Css.end, Css.margin (Css.px -10) ] ]
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
            [ Text.customView [ Attributes.id labelId, css [ Css.margin4 Css.auto Css.auto (Css.px 25) Css.auto, Css.textAlign Css.center ] ] TextStyle.heading4 title
            , content
            ]
        , Html.div [ css [ Css.alignSelf Css.end, Css.displayFlex, Css.flexDirection Css.row, Css.property "gap" "10px" ] ] <| List.map (\( x, y ) -> Button.view x y) actionButtons
        ]


type Label
    = LabelledBy String
    | Label String


widget : Label -> List (Html.Attribute Never) -> List (Html msg) -> Html msg
widget label attrs content =
    Html.div
        (attrs
            ++ [ Role.dialog
               , case label of
                    LabelledBy s ->
                        Aria.labelledBy s

                    Label s ->
                        Aria.label s
               , Attributes.css <|
                    [ Css.position Css.absolute
                    , Css.borderRadius (Css.px 10)
                    , Css.backgroundColor <| toCssColor Palette.white
                    , shadow Shadow.Large
                    ]
               ]
        )
        content
