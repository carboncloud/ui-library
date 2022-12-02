module Ui.Icon exposing (Icon, setFill, view, chevronLeft, chevronRight, edit, close)

{-| Defines a Button component


# Types

@docs Icon


# Views

@docs view

# Helpers

@docs setFill

# Icons

@docs chevronLeft, chevronRight, edit, close

-}
import Accessibility.Styled.Role as Role
import Color exposing (Color)
import Css
import Css.Global exposing (children)
import Html.Styled as Html exposing (Html)
import Svg.Styled as Svg exposing (Attribute, Svg, path, svg, text)
import Svg.Styled.Attributes as SvgAttr
import Ui.Color exposing (toCssColor)


{-| Defines the Icon type
-}
type Icon
    = Icon
        { label : String
        , attributes : List (Attribute Never)
        , children : List (Svg Never)
        }

{-| Set a fill color for the given icon
-}
setFill : Color -> Icon -> Icon
setFill color (Icon ({ attributes } as icon)) =
    Icon { icon | attributes = attributes ++ [ SvgAttr.css [ Css.fill <| toCssColor color ] ] }

{-| Creates a view for the given icon
-}
view : Icon -> Html msg
view (Icon { label, attributes, children }) =
    svg
        ([ Role.img
         , SvgAttr.height "100%"
         , SvgAttr.width "100%"
         , SvgAttr.pointerEvents "none"
         ]
            ++ attributes
        )
        (Svg.title [] [ Svg.text label ] :: children)
        |> Html.map never

{-| Chevron left icon
-}
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


{-| Chevron right icon
-}
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

{-| Edit icon
-}
edit : Icon
edit =
    Icon
        { label = "edit"
        , attributes = [ SvgAttr.viewBox "0 0 512 512" ]
        , children =
            [ path
                [ SvgAttr.d "m292.925781 86.839844 26.429688-26.429688 132.230469 132.230469-26.425782 26.429687zm0 0" ]
                []
            , path [ SvgAttr.d "m52.332031 327.429688 219.367188-219.367188 55.5 55.503906-219.363281 219.367188zm0 0" ] []
            , path [ SvgAttr.d "m129.0625 404.160156 219.363281-219.363281 55.503907 55.5-219.363282 219.367187zm0 0" ] []
            , path [ SvgAttr.d "m33.449219 351-33.449219 161 161-33.449219zm0 0" ] []
            , path [ SvgAttr.d "m491.554688 53.808594-33.363282-33.363282c-27.257812-27.261718-71.613281-27.261718-98.871094 0l-18.734374 18.734376 132.234374 132.234374 18.734376-18.734374c27.257812-27.261719 27.257812-71.613282 0-98.871094zm0 0" ] []
            ]
        }

{-| Close icon
-}
close : Icon
close =
    Icon
        { label = "close"
        , attributes =
            [ SvgAttr.viewBox "0 0 1792 1792"
            , SvgAttr.stroke "none"
            ]
        , children =
            [ path
                [ SvgAttr.d "M1490 1322q0 40-28 68l-136 136q-28 28-68 28t-68-28l-294-294-294 294q-28 28-68 28t-68-28l-136-136q-28-28-28-68t28-68l294-294-294-294q-28-28-28-68t28-68l136-136q28-28 68-28t68 28l294 294 294-294q28-28 68-28t68 28l136 136q28 28 28 68t-28 68l-294 294 294 294q28 28 28 68z"
                ]
                []
            ]
        }
