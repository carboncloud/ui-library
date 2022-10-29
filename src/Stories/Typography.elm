module Stories.Typography exposing (..)

import Color.Internal exposing (toHexString)
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Color as Color
import Ui.TextStyle as TextStyle
import Ui.Palette as Palette
import Ui.Typography as Typography


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
                , Css.property "gap" "45px"
                , Css.backgroundColor <| Color.toCssColor Palette.white
                , Css.justifyContent Css.center
                ]
            ]
            [ Styled.div
                [ Attributes.css
                    [ Css.displayFlex
                    , Css.flexDirection Css.column
                    , Css.backgroundColor <| Color.toCssColor Palette.white
                    ]
                ]
                [ Typography.styledText TextStyle.heading1 "H1 Headline"
                , Typography.styledText TextStyle.heading2 "H2 Headline"
                , Typography.styledText TextStyle.heading3 "H3 Headline"
                , Typography.styledText TextStyle.heading4 "H4 Headline"
                , Typography.styledText TextStyle.bodyLarge "Body large"
                , Typography.styledText TextStyle.body "Body"
                , Typography.styledText TextStyle.bodySmall "Body small"
                ]
            , Styled.div
                [ Attributes.css
                    [ Css.displayFlex
                    , Css.flexDirection Css.column
                    , Css.backgroundColor <| Color.toCssColor Palette.white
                    , Css.width (Css.pct 50)
                    ]
                ]
                [ Typography.styledText TextStyle.heading1 "Headline 1"
                , Typography.styledText TextStyle.heading2 "Headline 2"
                , Typography.styledParagraph TextStyle.body """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec non magna lorem. Integer ultrices, odio sit amet tincidunt semper, augue odio elementum tellus, sollicitudin varius nisi magna vitae nunc. Nulla ornare tincidunt ultrices. Nulla pulvinar ligula volutpat tellus commodo, ut lobortis nisl aliquet. Suspendisse scelerisque pharetra risus, ac ultricies ligula sodales ac. Pellentesque tempor, ligula sit amet lacinia egestas, velit nunc bibendum erat, vel ornare mi sem non lacus. Pellentesque congue sagittis sem laoreet vulputate. Aliquam erat volutpat. 
                    """
                , Typography.styledParagraph TextStyle.body """
                    In sed risus enim. Sed lobortis rutrum ante ac posuere. Vestibulum nec sem eget justo blandit porttitor ac ac ipsum. Integer et justo ac orci tristique accumsan. Nullam dictum, nulla at malesuada sodales, sapien lorem venenatis justo, id luctus nisi mauris eu ex. Etiam in maximus felis. Nullam sed ipsum vulputate, venenatis massa ac, volutpat lectus. Morbi pretium hendrerit orci vitae mollis. 
                    """
                ]
            ]
