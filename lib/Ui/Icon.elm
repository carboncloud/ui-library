module Ui.Icon exposing
    ( Icon
    , view
    , setFill
    , chevronLeft, chevronRight, edit, close
    , search
    )

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


{-| Search icon
-}
search : Icon
search =
    Icon
        { label = "close"
        , attributes =
            [ SvgAttr.viewBox "0 0 17 16"
            ]
        , children =
            [ path
                [ SvgAttr.d "M11.8473 9.4959C12.7232 8.28235 13.1101 6.79386 12.9334 5.31725C12.7567 3.84064 12.0289 2.48042 10.8902 1.49871C9.7516 0.517002 8.28273 -0.0167192 6.76666 0.000399385C5.2506 0.017518 3.79465 0.584264 2.67938 1.59142C1.5641 2.59858 0.868437 3.97488 0.726439 5.45508C0.584441 6.93529 1.00616 8.41466 1.91033 9.6081C2.8145 10.8015 4.13712 11.6246 5.62333 11.9187C7.10954 12.2127 8.65415 11.957 9.95951 11.2007L14.4874 15.6123C14.7225 15.8526 15.0452 15.9919 15.3847 15.9997C15.7243 16.0074 16.0532 15.883 16.2994 15.6536C16.5457 15.4243 16.6893 15.1086 16.6989 14.7757C16.7085 14.4428 16.5833 14.1196 16.3506 13.877C16.3353 13.8611 16.3201 13.8461 16.3013 13.8311L11.8473 9.4959ZM6.83317 9.907C5.78425 9.90662 4.77843 9.4977 4.03694 8.77019C3.29545 8.04268 2.879 7.05614 2.8792 6.02757C2.87939 4.999 3.29621 4.01262 4.03799 3.28538C4.77976 2.55814 5.78573 2.14959 6.83465 2.14959C7.88358 2.14959 8.88955 2.55814 9.63132 3.28538C10.3731 4.01262 10.7899 4.999 10.7901 6.02757C10.7903 7.05614 10.3739 8.04268 9.63237 8.77019C8.89087 9.4977 7.88505 9.90662 6.83613 9.907H6.83317Z"
                ]
                []
            ]
        }
