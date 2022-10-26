module Stories.Typography exposing (..)


import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color exposing (Color)
import Ui.Palette exposing (palette)
import Color.Internal exposing (toHexString)
import Ui.Styled.Text as Text
import Ui.Typography as Typography
import Ui.Css

main : Component () msg
main =
    Storybook.Component.stateless
        { controls = Storybook.Controls.none
        , view = \_ -> view
        }

view : Html msg
view =
    Styled.toUnstyled <|
        Styled.div [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "35px", Css.backgroundColor <| Ui.Css.fromColor palette.white] ]
            [ 
                Text.view Typography.bodyS "Body small",
                Text.view Typography.body "Body",
                Text.view Typography.bodyL "Body large",
                Text.view Typography.header "Header"
            ]
