module Stories.Icon exposing (..)

import Css exposing (displayFlex, flex)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (toUnstyled)
import Ui.Button exposing (ButtonEmphasis(..))
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.Shadow


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
        Styled.div [ css [ displayFlex, Css.property "gap" "20px" ] ] <|
            ([ Icon.edit, Icon.settings, Icon.comment, Icon.search, Icon.close, Icon.chevronUp, Icon.chevronRight, Icon.chevronDown, Icon.chevronLeft, Icon.chevronRight, Icon.newWindow ]
                |> List.map (Styled.div [ css [ Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.gray900), Css.backgroundColor <| toCssColor Ui.Palette.gray050, Css.width (Css.px 32), Css.height (Css.px 32) ] ] << List.singleton << Icon.view)
            )
