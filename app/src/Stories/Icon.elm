module Stories.Icon exposing (..)

import Css exposing (displayFlex)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (toUnstyled)
import Ui.Button exposing (ButtonEmphasis(..))
import Ui.Icon as Icon exposing (Icon)
import Ui.Text as Text
import Ui.TextStyle as TextStyle


main : Component () Msg
main =
    Storybook.Component.stateless
        { controls = Storybook.Controls.none
        , view = always view
        }


type alias Controls =
    { label : String
    , emphasis : ButtonEmphasis
    }


type Msg
    = UserClickedButton


view : Html Msg
view =
    toUnstyled <|
        Styled.div [ css [ displayFlex, Css.flexDirection Css.column, Css.property "gap" "45px" ] ]
            [ iconGroup "Actions" [ Icon.edit, Icon.copy, Icon.settings, Icon.delete, Icon.comment, Icon.search, Icon.close, Icon.newWindow, Icon.more ]
            , iconGroup "Domain" [Icon.product]
            , iconGroup "Chevron" [ Icon.chevronUp, Icon.chevronRight, Icon.chevronDown, Icon.chevronLeft ]
            ]


iconGroup : String -> List Icon -> Styled.Html msg
iconGroup name icons =
    Styled.div []
        [ Text.view TextStyle.heading3 name
        , Styled.div [ css [ displayFlex, Css.property "gap" "20px", Css.marginTop (Css.px 10) ] ] <|
            (icons
                |> List.map (Styled.div [ css [ Css.width (Css.px 24), Css.height (Css.px 24) ] ] << List.singleton << Icon.view24x24)
            )
        ]
