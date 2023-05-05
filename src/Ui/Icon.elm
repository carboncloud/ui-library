module Ui.Icon exposing
    ( Icon(..)
    , view
    , setFill
    , chevronUp, chevronLeft, chevronRight, chevronDown, edit, close, search, newWindow, comment, settings
    )

{-| Defines a Button component


# Types

@docs Icon


# Views

@docs view


# Helpers

@docs setFill


# Icons

@docs chevronUp, chevronLeft, chevronRight, chevronDown, edit, close, search, newWindow, comment, settings

-}

import Accessibility.Styled.Role as Role
import Color exposing (Color)
import Css
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
            , SvgAttr.viewBox "0 0 455.37 809.49"
            ]
        , children =
            [ path
                [ SvgAttr.d "m440.76,86.19L122.21,404.74l318.55,318.56c19.65,19.88,19.46,51.93-.43,71.58-19.71,19.47-51.43,19.47-71.15,0L14.83,440.54c-19.77-19.77-19.77-51.82,0-71.58L369.18,14.61c19.88-19.65,51.93-19.46,71.58.44,19.47,19.71,19.47,51.43,0,71.16v-.02Z"
                ]
                []
            ]
        }


{-| -}
chevronUp : Icon
chevronUp =
    Icon
        { label = "chevron-up"
        , attributes =
            [ SvgAttr.x "0px"
            , SvgAttr.y "0px"
            , SvgAttr.viewBox "0 0 809.49 455.37"
            ]
        , children =
            [ path
                [ SvgAttr.d "m723.3,440.76L404.75,122.21,86.19,440.76c-19.88,19.65-51.93,19.46-71.58-.43-19.47-19.71-19.47-51.43,0-71.15L368.95,14.83c19.77-19.77,51.82-19.77,71.58,0l354.35,354.35c19.65,19.88,19.46,51.93-.44,71.58-19.71,19.47-51.43,19.47-71.16,0h.02Z"
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
            , SvgAttr.viewBox "0 0 15 26"
            ]
        , children =
            [ path
                [ SvgAttr.d "M1.15076 22.6979L10.9885 12.8602L1.15076 3.022C0.543998 2.4079 0.54986 1.41812 1.16395 0.811357C1.77267 0.209966 2.75219 0.209966 3.3614 0.811357L14.3047 11.7546C14.9153 12.3653 14.9153 13.3551 14.3047 13.9653L3.3614 24.9085C2.74731 25.5153 1.75753 25.5094 1.15076 24.8949C0.549372 24.2861 0.549372 23.3066 1.15076 22.6974V22.6979Z"
                ]
                []
            ]
        }


{-| -}
chevronDown : Icon
chevronDown =
    Icon
        { label = "chevron-down"
        , attributes =
            [ SvgAttr.x "0px"
            , SvgAttr.y "0px"
            , SvgAttr.viewBox "0 0 809.49 455.37"
            ]
        , children =
            [ path
                [ SvgAttr.d "m86.19,14.61l318.55,318.55L723.3,14.61c19.88-19.65,51.93-19.46,71.58.43,19.47,19.71,19.47,51.43,0,71.15l-354.35,354.35c-19.77,19.77-51.82,19.77-71.58,0L14.61,86.19c-19.65-19.88-19.46-51.93.44-71.58,19.71-19.47,51.43-19.47,71.16,0h-.02Z"
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


{-| Open in new window icon
-}
newWindow : Icon
newWindow =
    Icon
        { label = "new-window"
        , attributes = [ SvgAttr.viewBox "0 0 12.5 12.5" ]
        , children =
            [ Svg.g
                []
                [ Svg.g [ SvgAttr.transform "translate(4.546)" ]
                    [ Svg.g [] [ Svg.path [ SvgAttr.style "stroke-width:5", SvgAttr.d "M193.57,0h-4.545a.568.568,0,1,0,0,1.136H192.2L186.35,6.985a.568.568,0,1,0,.8.8L193,1.94V5.114a.568.568,0,1,0,1.136,0V.568A.568.568,0,0,0,193.57,0Z", SvgAttr.transform "translate(-186.184)" ] [] ]
                    ]
                , Svg.g [ SvgAttr.transform "translate(0 2.273)" ] [ Svg.g [] [ Svg.path [ SvgAttr.style "stroke-width:5", SvgAttr.d "M9.659,96.5a.568.568,0,0,0-.568.568v5.114H1.136V94.227H6.25a.568.568,0,1,0,0-1.136H.568A.568.568,0,0,0,0,93.659v9.091a.568.568,0,0,0,.568.568H9.659a.568.568,0,0,0,.568-.568V97.068A.568.568,0,0,0,9.659,96.5Z", SvgAttr.transform "translate(0 -93.091)" ] [] ] ]
                ]
            ]
        }


{-| -}
comment : Icon
comment =
    Icon
        { label = "comment-icon"
        , attributes = [ SvgAttr.viewBox "-21 -47 682.66669 682" ]
        , children =
            [ path
                [ SvgAttr.d "m552.011719-1.332031h-464.023438c-48.515625 0-87.988281 39.472656-87.988281 87.988281v283.972656c0 48.421875 39.300781 87.824219 87.675781 87.988282v128.871093l185.183594-128.859375h279.152344c48.515625 0 87.988281-39.472656 87.988281-88v-283.972656c0-48.515625-39.472656-87.988281-87.988281-87.988281zm-83.308594 330.011719h-297.40625v-37.5h297.40625zm0-80h-297.40625v-37.5h297.40625zm0-80h-297.40625v-37.5h297.40625zm0 0"
                ]
                []
            ]
        }


{-| -}
settings : Icon
settings =
    Icon
        { label = "settings-icon"
        , attributes = [ SvgAttr.viewBox "0 0 24 24" ]
        , children =
            [ path
                [ SvgAttr.d "m22.683 9.394-1.88-.239c-.155-.477-.346-.937-.569-1.374l1.161-1.495c.47-.605.415-1.459-.122-1.979l-1.575-1.575c-.525-.542-1.379-.596-1.985-.127l-1.493 1.161c-.437-.223-.897-.414-1.375-.569l-.239-1.877c-.09-.753-.729-1.32-1.486-1.32h-2.24c-.757 0-1.396.567-1.486 1.317l-.239 1.88c-.478.155-.938.345-1.375.569l-1.494-1.161c-.604-.469-1.458-.415-1.979.122l-1.575 1.574c-.542.526-.597 1.38-.127 1.986l1.161 1.494c-.224.437-.414.897-.569 1.374l-1.877.239c-.753.09-1.32.729-1.32 1.486v2.24c0 .757.567 1.396 1.317 1.486l1.88.239c.155.477.346.937.569 1.374l-1.161 1.495c-.47.605-.415 1.459.122 1.979l1.575 1.575c.526.541 1.379.595 1.985.126l1.494-1.161c.437.224.897.415 1.374.569l.239 1.876c.09.755.729 1.322 1.486 1.322h2.24c.757 0 1.396-.567 1.486-1.317l.239-1.88c.477-.155.937-.346 1.374-.569l1.495 1.161c.605.47 1.459.415 1.979-.122l1.575-1.575c.542-.526.597-1.379.127-1.985l-1.161-1.494c.224-.437.415-.897.569-1.374l1.876-.239c.753-.09 1.32-.729 1.32-1.486v-2.24c.001-.757-.566-1.396-1.316-1.486zm-10.683 7.606c-2.757 0-5-2.243-5-5s2.243-5 5-5 5 2.243 5 5-2.243 5-5 5z"
                ]
                []
            ]
        }
