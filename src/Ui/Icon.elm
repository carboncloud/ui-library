module Ui.Icon exposing (..)

import Accessibility.Styled.Role as Role
import Css.Global exposing (children)
import Html.Styled as Html exposing (Html)
import Svg.Styled as Svg exposing (Attribute, Svg, path, svg, text)
import Svg.Styled.Attributes as SvgAttr


type Icon
    = Icon
        { label : String
        , attributes : List (Attribute Never)
        , children : List (Svg Never)
        }


toStyled : Icon -> Html msg
toStyled (Icon { label, attributes, children }) =
    svg
        (Role.img
            :: [ SvgAttr.height "100%"
               , SvgAttr.width "100%"
               ]
            ++ attributes
        )
        (Svg.title [] [ Svg.text label ] :: children)
        |> Html.map never


chevronLeft : Icon
chevronLeft =
    Icon
        { label = "chevron-left"
        , attributes =
            [ SvgAttr.x "0px"
            , SvgAttr.y "0px"
            , SvgAttr.viewBox "0 0 7.8 13"
            ]
        , children =
            [ path
                [ SvgAttr.d "M7.5,12.6c0.5-0.5,0.5-1.4,0-1.9L3.3,6.5l4.2-4.2C8,1.8,8,0.9,7.5,0.4s-1.4-0.5-1.9,0L0.5,5.5l0,0\n\tc-0.6,0.6-0.6,1.4-0.1,2l0,0l0,0l0,0l5.1,5.1C6.1,13.1,7,13.1,7.5,12.6z"
                ]
                []
            ]
        }


chevronRight : Icon
chevronRight =
    Icon
        { label = "chevron-right"
        , attributes =
            [ SvgAttr.x "0px"
            , SvgAttr.y "0px"
            , SvgAttr.viewBox "0 0 7.8 13"
            ]
        , children =
            [ path
                [ SvgAttr.d "M0.4,0.4c-0.5,0.5-0.5,1.4,0,1.9l4.2,4.2l-4.2,4.2c-0.5,0.5-0.5,1.4,0,1.9s1.4,0.5,1.9,0l5.1-5.1l0,0\n\tC8,6.9,8,6.1,7.5,5.5l0,0l0,0l0,0L2.4,0.4C1.8-0.1,0.9-0.1,0.4,0.4z"
                ]
                []
            ]
        }
