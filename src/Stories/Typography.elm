module Stories.Typography exposing (..)

import Color.Internal exposing (toHexString)
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color
import Ui.Palette as Palette
import Ui.Text as Text
import Ui.Font as Font


main : Component () msg
main =
    Storybook.Component.stateless
        { controls = Storybook.Controls.none
        , view = \_ -> view
        }


view : Html msg
view =
    Styled.toUnstyled <|
        Styled.div
            [ Attributes.css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Css.property "gap" "35px"
                , Css.backgroundColor <| Color.toCssColor Palette.white
                ]
            ]
            [ Text.view Font.h1 "H1 Headline"
            , Text.view Font.h2 "H2 Headline"
            , Text.view Font.h3 "H3 Headline"
            , Text.view Font.h4 "H4 Headline"
            , Text.view Font.bodyS "Body small"
            , Text.view Font.body "Body"
            , Text.view Font.bodyL "Body large"
            ]
