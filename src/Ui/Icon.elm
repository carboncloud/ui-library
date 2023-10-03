module Ui.Icon exposing
    ( Icon(..)
    , view
    , setFill
    , chevronUp, chevronLeft, chevronRight, chevronDown, edit, close, search, newWindow, comment, settings
    , approved, broken, copy, delete, distributionCenter, draft, factory, farmgate, more, needClarification, store, underReview, view24x24, waitingForReview
    )

{-|


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
import Svg.Styled as Svg exposing (Attribute, Svg, path, svg)
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
setFill color (Icon ({ attributes } as icon_)) =
    Icon { icon_ | attributes = attributes ++ [ SvgAttr.css [ Css.fill <| toCssColor color ] ] }


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


view24x24 : Icon -> Html msg
view24x24 (Icon { label, attributes, children }) =
    svg
        ([ Role.img
         , SvgAttr.height "24px"
         , SvgAttr.width "24px"
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
    icon "chevron-left-icon" <|
        path
            [ SvgAttr.d "M13.3 17.3L8.7 12.7C8.6 12.6 8.52917 12.4917 8.4875 12.375C8.44583 12.2583 8.425 12.1333 8.425 12C8.425 11.8667 8.44583 11.7417 8.4875 11.625C8.52917 11.5083 8.6 11.4 8.7 11.3L13.3 6.69999C13.4833 6.51665 13.7167 6.42499 14 6.42499C14.2833 6.42499 14.5167 6.51665 14.7 6.69999C14.8833 6.88332 14.975 7.11665 14.975 7.39999C14.975 7.68332 14.8833 7.91665 14.7 8.09999L10.8 12L14.7 15.9C14.8833 16.0833 14.975 16.3167 14.975 16.6C14.975 16.8833 14.8833 17.1167 14.7 17.3C14.5167 17.4833 14.2833 17.575 14 17.575C13.7167 17.575 13.4833 17.4833 13.3 17.3Z"
            ]
            []


{-| -}
chevronUp : Icon
chevronUp =
    icon "chevron-up-icon" <|
        path
            [ SvgAttr.d "M6.97759 14.3833C6.79426 14.2 6.70259 13.9667 6.70259 13.6833C6.70259 13.4 6.79426 13.1667 6.97759 12.9833L11.5776 8.38334C11.6776 8.28334 11.7859 8.2125 11.9026 8.17084C12.0193 8.12917 12.1443 8.10834 12.2776 8.10834C12.4109 8.10834 12.5359 8.12917 12.6526 8.17084C12.7693 8.2125 12.8776 8.28334 12.9776 8.38334L17.6026 13.0083C17.7859 13.1917 17.8776 13.4167 17.8776 13.6833C17.8776 13.95 17.7776 14.1833 17.5776 14.3833C17.3943 14.5667 17.1609 14.6583 16.8776 14.6583C16.5943 14.6583 16.3609 14.5667 16.1776 14.3833L12.2776 10.4833L8.35259 14.4083C8.16926 14.5917 7.94426 14.6833 7.67759 14.6833C7.41092 14.6833 7.17759 14.5833 6.97759 14.3833Z"
            ]
            []


{-| Chevron right icon
-}
chevronRight : Icon
chevronRight =
    icon "chevron-right-icon" <|
        path
            [ SvgAttr.d "M8.7 17.3C8.51667 17.1167 8.425 16.8833 8.425 16.6C8.425 16.3167 8.51667 16.0833 8.7 15.9L12.6 12L8.7 8.09999C8.51667 7.91665 8.425 7.68332 8.425 7.39999C8.425 7.11665 8.51667 6.88332 8.7 6.69999C8.88334 6.51665 9.11667 6.42499 9.4 6.42499C9.68334 6.42499 9.91667 6.51665 10.1 6.69999L14.7 11.3C14.8 11.4 14.8708 11.5083 14.9125 11.625C14.9542 11.7417 14.975 11.8667 14.975 12C14.975 12.1333 14.9542 12.2583 14.9125 12.375C14.8708 12.4917 14.8 12.6 14.7 12.7L10.1 17.3C9.91667 17.4833 9.68334 17.575 9.4 17.575C9.11667 17.575 8.88334 17.4833 8.7 17.3Z"
            ]
            []


{-| -}
chevronDown : Icon
chevronDown =
    icon "chevron-down-icon" <|
        path
            [ SvgAttr.d "M12 14.95C11.8667 14.95 11.7417 14.9292 11.625 14.8875C11.5083 14.8458 11.4 14.775 11.3 14.675L6.675 10.05C6.49167 9.86667 6.40417 9.63751 6.4125 9.36251C6.42083 9.08751 6.51667 8.85834 6.7 8.67501C6.88333 8.49167 7.11667 8.40001 7.4 8.40001C7.68333 8.40001 7.91667 8.49167 8.1 8.67501L12 12.575L15.925 8.65001C16.1083 8.46667 16.3375 8.37917 16.6125 8.38751C16.8875 8.39584 17.1167 8.49167 17.3 8.67501C17.4833 8.85834 17.575 9.09167 17.575 9.37501C17.575 9.65834 17.4833 9.89167 17.3 10.075L12.7 14.675C12.6 14.775 12.4917 14.8458 12.375 14.8875C12.2583 14.9292 12.1333 14.95 12 14.95Z"
            ]
            []


{-| Edit icon
-}
edit : Icon
edit =
    icon "edit-icon" <|
        path
            [ SvgAttr.d "M19.0538 9.09041L14.868 4.94795L16.2469 3.56712C16.6244 3.18904 17.0881 3 17.638 3C18.1879 3 18.6516 3.18904 19.0292 3.56712L20.408 4.94795C20.7856 5.32603 20.9826 5.78219 20.999 6.31644C21.0154 6.85068 20.8348 7.30685 20.4573 7.68493L19.0538 9.09041ZM17.6257 10.5452L7.18581 21H3V16.8082L13.4399 6.35342L17.6257 10.5452Z"
            ]
            []


{-| Close icon
-}
close : Icon
close =
    icon "close-icon" <|
        path
            [ SvgAttr.d "M12 13.4905L6.78327 18.7072C6.58809 18.9024 6.33967 19 6.03802 19C5.73638 19 5.48796 18.9024 5.29278 18.7072C5.09759 18.512 5 18.2636 5 17.962C5 17.6603 5.09759 17.4119 5.29278 17.2167L10.5095 12L5.29278 6.78327C5.09759 6.58809 5 6.33967 5 6.03802C5 5.73638 5.09759 5.48796 5.29278 5.29278C5.48796 5.09759 5.73638 5 6.03802 5C6.33967 5 6.58809 5.09759 6.78327 5.29278L12 10.5095L17.2167 5.29278C17.4119 5.09759 17.6603 5 17.962 5C18.2636 5 18.512 5.09759 18.7072 5.29278C18.9024 5.48796 19 5.73638 19 6.03802C19 6.33967 18.9024 6.58809 18.7072 6.78327L13.4905 12L18.7072 17.2167C18.9024 17.4119 19 17.6603 19 17.962C19 18.2636 18.9024 18.512 18.7072 18.7072C18.512 18.9024 18.2636 19 17.962 19C17.6603 19 17.4119 18.9024 17.2167 18.7072L12 13.4905Z"
            ]
            []


{-| Search icon
-}
search : Icon
search =
    icon "search-icon" <|
        path
            [ SvgAttr.d "M19.0006 20.3667L13.4006 14.7667C12.9006 15.1667 12.3256 15.4833 11.6756 15.7167C11.0256 15.95 10.3339 16.0667 9.6006 16.0667C7.78393 16.0667 6.24643 15.4375 4.9881 14.1792C3.72977 12.9208 3.1006 11.3833 3.1006 9.56665C3.1006 7.74998 3.72977 6.21248 4.9881 4.95415C6.24643 3.69582 7.78393 3.06665 9.6006 3.06665C11.4173 3.06665 12.9548 3.69582 14.2131 4.95415C15.4714 6.21248 16.1006 7.74998 16.1006 9.56665C16.1006 10.3 15.9839 10.9917 15.7506 11.6417C15.5173 12.2917 15.2006 12.8667 14.8006 13.3667L20.4256 18.9917C20.6089 19.175 20.7006 19.4 20.7006 19.6667C20.7006 19.9333 20.6006 20.1667 20.4006 20.3667C20.2173 20.55 19.9839 20.6417 19.7006 20.6417C19.4173 20.6417 19.1839 20.55 19.0006 20.3667ZM9.6006 14.0667C10.8506 14.0667 11.9131 13.6292 12.7881 12.7542C13.6631 11.8792 14.1006 10.8167 14.1006 9.56665C14.1006 8.31665 13.6631 7.25415 12.7881 6.37915C11.9131 5.50415 10.8506 5.06665 9.6006 5.06665C8.3506 5.06665 7.2881 5.50415 6.4131 6.37915C5.5381 7.25415 5.1006 8.31665 5.1006 9.56665C5.1006 10.8167 5.5381 11.8792 6.4131 12.7542C7.2881 13.6292 8.3506 14.0667 9.6006 14.0667Z"
            ]
            []


{-| Open in new window icon
-}
newWindow : Icon
newWindow =
    icon "open-in-new-icon" <|
        path
            [ SvgAttr.d "M5 21C4.45 21 3.97917 20.8042 3.5875 20.4125C3.19583 20.0208 3 19.55 3 19V5C3 4.45 3.19583 3.97917 3.5875 3.5875C3.97917 3.19583 4.45 3 5 3H12V5H5V19H19V12H21V19C21 19.55 20.8042 20.0208 20.4125 20.4125C20.0208 20.8042 19.55 21 19 21H5ZM9.7 15.7L8.3 14.3L17.6 5H14V3H21V10H19V6.4L9.7 15.7Z"
            ]
            []


{-| -}
comment : Icon
comment =
    icon "comment-icon" <|
        path
            [ SvgAttr.d "M7.75 14.3193H12.85C13.0908 14.3193 13.2927 14.2369 13.4556 14.0721C13.6185 13.9072 13.7 13.703 13.7 13.4593C13.7 13.2157 13.6185 13.0115 13.4556 12.8466C13.2927 12.6818 13.0908 12.5994 12.85 12.5994H7.75C7.50917 12.5994 7.30729 12.6818 7.14438 12.8466C6.98146 13.0115 6.9 13.2157 6.9 13.4593C6.9 13.703 6.98146 13.9072 7.14438 14.0721C7.30729 14.2369 7.50917 14.3193 7.75 14.3193ZM7.75 11.7395H16.25C16.4908 11.7395 16.6927 11.6571 16.8556 11.4922C17.0185 11.3274 17.1 11.1232 17.1 10.8795C17.1 10.6359 17.0185 10.4316 16.8556 10.2668C16.6927 10.102 16.4908 10.0196 16.25 10.0196H7.75C7.50917 10.0196 7.30729 10.102 7.14438 10.2668C6.98146 10.4316 6.9 10.6359 6.9 10.8795C6.9 11.1232 6.98146 11.3274 7.14438 11.4922C7.30729 11.6571 7.50917 11.7395 7.75 11.7395ZM7.75 9.15964H16.25C16.4908 9.15964 16.6927 9.07723 16.8556 8.91241C17.0185 8.74759 17.1 8.54335 17.1 8.2997C17.1 8.05605 17.0185 7.85182 16.8556 7.687C16.6927 7.52217 16.4908 7.43976 16.25 7.43976H7.75C7.50917 7.43976 7.30729 7.52217 7.14438 7.687C6.98146 7.85182 6.9 8.05605 6.9 8.2997C6.9 8.54335 6.98146 8.74759 7.14438 8.91241C7.30729 9.07723 7.50917 9.15964 7.75 9.15964ZM6.9 17.7591L4.945 19.7369C4.67583 20.0092 4.36771 20.0701 4.02063 19.9197C3.67354 19.7692 3.5 19.5004 3.5 19.1135V5.71988C3.5 5.24691 3.66646 4.84203 3.99938 4.50522C4.33229 4.16841 4.7325 4 5.2 4H18.8C19.2675 4 19.6677 4.16841 20.0006 4.50522C20.3335 4.84203 20.5 5.24691 20.5 5.71988V16.0392C20.5 16.5121 20.3335 16.917 20.0006 17.2538C19.6677 17.5906 19.2675 17.7591 18.8 17.7591H6.9Z"
            ]
            []


{-| -}
settings : Icon
settings =
    icon "settings-icon" <|
        path
            [ SvgAttr.d "M13.875 22H10.125C9.875 22 9.65834 21.9167 9.475 21.75C9.29167 21.5833 9.18333 21.375 9.15 21.125L8.85 18.8C8.63334 18.7167 8.42917 18.6167 8.2375 18.5C8.04583 18.3833 7.85833 18.2583 7.675 18.125L5.5 19.025C5.26667 19.1083 5.03334 19.1167 4.8 19.05C4.56667 18.9833 4.38334 18.8417 4.25 18.625L2.4 15.4C2.26667 15.1833 2.225 14.95 2.275 14.7C2.325 14.45 2.45 14.25 2.65 14.1L4.525 12.675C4.50834 12.5583 4.5 12.4458 4.5 12.3375V11.6625C4.5 11.5542 4.50834 11.4417 4.525 11.325L2.65 9.9C2.45 9.75 2.325 9.55 2.275 9.3C2.225 9.05 2.26667 8.81667 2.4 8.6L4.25 5.375C4.36667 5.14167 4.54584 4.99583 4.7875 4.9375C5.02917 4.87917 5.26667 4.89167 5.5 4.975L7.675 5.875C7.85833 5.74167 8.05 5.61667 8.25 5.5C8.45 5.38333 8.65 5.28333 8.85 5.2L9.15 2.875C9.18333 2.625 9.29167 2.41667 9.475 2.25C9.65834 2.08333 9.875 2 10.125 2H13.875C14.125 2 14.3417 2.08333 14.525 2.25C14.7083 2.41667 14.8167 2.625 14.85 2.875L15.15 5.2C15.3667 5.28333 15.5708 5.38333 15.7625 5.5C15.9542 5.61667 16.1417 5.74167 16.325 5.875L18.5 4.975C18.7333 4.89167 18.9667 4.88333 19.2 4.95C19.4333 5.01667 19.6167 5.15833 19.75 5.375L21.6 8.6C21.7333 8.81667 21.775 9.05 21.725 9.3C21.675 9.55 21.55 9.75 21.35 9.9L19.475 11.325C19.4917 11.4417 19.5 11.5542 19.5 11.6625V12.3375C19.5 12.4458 19.4833 12.5583 19.45 12.675L21.325 14.1C21.525 14.25 21.65 14.45 21.7 14.7C21.75 14.95 21.7083 15.1833 21.575 15.4L19.725 18.6C19.5917 18.8167 19.4042 18.9625 19.1625 19.0375C18.9208 19.1125 18.6833 19.1083 18.45 19.025L16.325 18.125C16.1417 18.2583 15.95 18.3833 15.75 18.5C15.55 18.6167 15.35 18.7167 15.15 18.8L14.85 21.125C14.8167 21.375 14.7083 21.5833 14.525 21.75C14.3417 21.9167 14.125 22 13.875 22ZM12.05 15.5C13.0167 15.5 13.8417 15.1583 14.525 14.475C15.2083 13.7917 15.55 12.9667 15.55 12C15.55 11.0333 15.2083 10.2083 14.525 9.525C13.8417 8.84167 13.0167 8.5 12.05 8.5C11.0667 8.5 10.2375 8.84167 9.5625 9.525C8.8875 10.2083 8.55 11.0333 8.55 12C8.55 12.9667 8.8875 13.7917 9.5625 14.475C10.2375 15.1583 11.0667 15.5 12.05 15.5Z"
            ]
            []


draft : Icon
draft =
    icon "draft-icon" <|
        path
            [ SvgAttr.d "M7.49848 3.3389C8.97054 2.48717 10.6799 2 12.5 2C14.3201 2 16.0295 2.48717 17.5015 3.3389C17.9796 3.61548 18.1429 4.22723 17.8663 4.70526C17.5897 5.1833 16.9779 5.3466 16.4999 5.07001C15.3241 4.3897 13.9591 4 12.5 4C11.0409 4 9.67591 4.3897 8.50009 5.07001C8.02205 5.3466 7.41031 5.1833 7.13372 4.70526C6.85713 4.22723 7.02044 3.61548 7.49848 3.3389ZM19.7947 6.63372C20.2728 6.35713 20.8845 6.52044 21.1611 6.99848C22.0128 8.47054 22.5 10.1799 22.5 12C22.5 13.8201 22.0128 15.5295 21.1611 17.0015C20.8845 17.4796 20.2728 17.6429 19.7947 17.3663C19.3167 17.0897 19.1534 16.4779 19.43 15.9999C20.1103 14.8241 20.5 13.4591 20.5 12C20.5 10.5409 20.1103 9.17591 19.43 8.00009C19.1534 7.52205 19.3167 6.91031 19.7947 6.63372ZM5.20526 6.63372C5.6833 6.91031 5.8466 7.52205 5.57001 8.00009C4.8897 9.17591 4.5 10.5409 4.5 12C4.5 13.4591 4.8897 14.8241 5.57001 15.9999C5.8466 16.4779 5.6833 17.0897 5.20526 17.3663C4.72723 17.6429 4.11548 17.4796 3.8389 17.0015C2.98717 15.5295 2.5 13.8201 2.5 12C2.5 10.1799 2.98717 8.47054 3.8389 6.99848C4.11548 6.52044 4.72723 6.35714 5.20526 6.63372ZM7.13372 19.2947C7.41031 18.8167 8.02205 18.6534 8.50009 18.93C9.67591 19.6103 11.0409 20 12.5 20C13.9591 20 15.3241 19.6103 16.4999 18.93C16.9779 18.6534 17.5897 18.8167 17.8663 19.2947C18.1429 19.7728 17.9796 20.3845 17.5015 20.6611C16.0295 21.5128 14.3201 22 12.5 22C10.6799 22 8.97054 21.5128 7.49848 20.6611C7.02044 20.3845 6.85714 19.7728 7.13372 19.2947Z"
            ]
            []


waitingForReview : Icon
waitingForReview =
    icon "waiting-for-review-icon" <|
        path
            [ SvgAttr.d "M12 2C10.1799 2 8.47054 2.48717 6.99848 3.3389C6.52044 3.61548 6.35713 4.22723 6.63372 4.70526C6.91031 5.1833 7.52205 5.3466 8.00009 5.07001C9.17591 4.3897 10.5409 4 12 4C13.4591 4 14.8241 4.3897 15.9999 5.07001C16.4779 5.3466 17.0897 5.1833 17.3663 4.70526C17.6429 4.22723 17.4796 3.61548 17.0015 3.3389C15.5295 2.48717 13.8201 2 12 2ZM20.6611 6.99848C20.3845 6.52044 19.7728 6.35713 19.2947 6.63372C18.8167 6.91031 18.6534 7.52205 18.93 8.00009C19.6103 9.17591 20 10.5409 20 12C20 13.4591 19.6103 14.8241 18.93 15.9999C18.6534 16.4779 18.8167 17.0897 19.2947 17.3663C19.7728 17.6429 20.3845 17.4796 20.6611 17.0015C21.5128 15.5295 22 13.8201 22 12C22 10.1799 21.5128 8.47054 20.6611 6.99848ZM5.07001 8.00009C5.3466 7.52205 5.1833 6.91031 4.70526 6.63372C4.22723 6.35713 3.61548 6.52044 3.3389 6.99848C2.48717 8.47054 2 10.1799 2 12C2 13.8201 2.48717 15.5295 3.3389 17.0015C3.61548 17.4796 4.22723 17.6429 4.70526 17.3663C5.1833 17.0897 5.3466 16.4779 5.07001 15.9999C4.3897 14.8241 4 13.4591 4 12C4 10.5409 4.3897 9.17591 5.07001 8.00009ZM8.00009 18.93C7.52205 18.6534 6.91031 18.8167 6.63372 19.2947C6.35713 19.7728 6.52044 20.3845 6.99848 20.6611C8.47054 21.5128 10.1799 22 12 22C13.8201 22 15.5295 21.5128 17.0015 20.6611C17.4796 20.3845 17.6429 19.7728 17.3663 19.2947C17.0897 18.8167 16.4779 18.6534 15.9999 18.93C14.8241 19.6103 13.4591 20 12 20C10.5409 20 9.17591 19.6103 8.00009 18.93ZM13 6C13 5.44772 12.5523 5 12 5C11.4477 5 11 5.44772 11 6V12C11 12.3788 11.214 12.725 11.5528 12.8944L15.5528 14.8944C16.0468 15.1414 16.6474 14.9412 16.8944 14.4472C17.1414 13.9532 16.9412 13.3526 16.4472 13.1056L13 11.382V6Z"
            ]
            []


underReview : Icon
underReview =
    icon "under-review-icon" <|
        path
            [ SvgAttr.d "M20 12C20 16.4183 16.4183 20 12 20C7.58172 20 4 16.4183 4 12C4 7.58172 7.58172 4 12 4C16.4183 4 20 7.58172 20 12ZM12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22ZM13 6C13 5.44772 12.5523 5 12 5C11.4477 5 11 5.44772 11 6V12C11 12.3788 11.214 12.725 11.5528 12.8944L15.5528 14.8944C16.0468 15.1414 16.6474 14.9412 16.8944 14.4472C17.1414 13.9532 16.9412 13.3526 16.4472 13.1056L13 11.382V6Z"
            ]
            []


needClarification : Icon
needClarification =
    icon "need-clarification-icon" <|
        Svg.g []
            [ Svg.circle
                [ SvgAttr.cx "12.5"
                , SvgAttr.cy "12"
                , SvgAttr.r "10"
                , SvgAttr.fill "#EADC60"
                ]
                []
            , path
                [ SvgAttr.d "M11.6375 8.21947C11.9563 8.02843 12.3287 7.95967 12.6898 8.02282C13.0511 8.08601 13.3829 8.2782 13.6243 8.57059C13.8661 8.86341 14.0006 9.23713 14 9.62583L14 9.62729C14 9.98002 13.7294 10.3749 13.1514 10.7678C12.8906 10.9451 12.6228 11.0823 12.4164 11.1759C12.3146 11.222 12.2312 11.2559 12.1756 11.2775C12.1479 11.2883 12.1274 11.2959 12.1152 11.3003L12.1035 11.3045L12.1028 11.3047C12.1028 11.3047 12.1027 11.3047 12.1027 11.3048C11.6987 11.4433 11.4271 11.8233 11.4271 12.2507V14C11.4271 14.5523 11.8748 15 12.4271 15C12.9794 15 13.4271 14.5523 13.4271 14V12.9105C13.6751 12.7897 13.9733 12.6275 14.2757 12.4218C14.9841 11.9404 15.9996 11.0239 16 9.62816L16 9.62876L15.0001 9.62729H16V9.62816C16.0011 8.77801 15.7073 7.95221 15.1666 7.29727C14.6254 6.64174 13.8708 6.19901 13.0344 6.05272C12.1977 5.9064 11.3383 6.06714 10.6095 6.50391C9.88108 6.94039 9.33205 7.62283 9.05471 8.42669C8.87458 8.94878 9.1518 9.51803 9.67388 9.69816C10.196 9.87828 10.7652 9.60107 10.9453 9.07898C11.0713 8.71398 11.3182 8.4108 11.6375 8.21947ZM12.5 16C11.9477 16 11.5 16.4477 11.5 17C11.5 17.5523 11.9477 18 12.5 18H12.51C13.0623 18 13.51 17.5523 13.51 17C13.51 16.4477 13.0623 16 12.51 16H12.5Z"
                ]
                []
            ]


approved : Icon
approved =
    icon "approved-icon" <|
        Svg.g []
            [ Svg.circle
                [ SvgAttr.cx "12.5"
                , SvgAttr.cy "12"
                , SvgAttr.r "10"
                , SvgAttr.fill "#7DCC70"
                ]
                []
            , path
                [ SvgAttr.fillRule "evenodd"
                , SvgAttr.clipRule "evenodd"
                , SvgAttr.d "M17.2559 9.24169C17.5814 9.5633 17.5814 10.0847 17.2559 10.4063L11.8393 15.7593C11.5138 16.0809 10.9862 16.0809 10.6607 15.7593L7.74408 12.8769C7.41864 12.5553 7.41864 12.0339 7.74408 11.7123C8.06951 11.3907 8.59715 11.3907 8.92259 11.7123L11.25 14.0123L16.0774 9.24169C16.4028 8.92009 16.9305 8.92009 17.2559 9.24169Z"
                , SvgAttr.fill "black"
                ]
                []
            ]


broken : Icon
broken =
    icon "broken-icon" <|
        Svg.g []
            [ path
                [ SvgAttr.d "M12 22.0005C17.5228 22.0005 22 17.5233 22 12.0005C22 6.47764 17.5228 2.00049 12 2.00049C6.47715 2.00049 2 6.47764 2 12.0005C2 17.5233 6.47715 22.0005 12 22.0005Z"
                , SvgAttr.fill "#FA876A"
                ]
                []
            , path
                [ SvgAttr.fillRule "evenodd"
                , SvgAttr.clipRule "evenodd"
                , SvgAttr.d "M13 7.00049C13 6.4482 12.5523 6.00049 12 6.00049C11.4477 6.00049 11 6.4482 11 7.00049V13.0005C11 13.5528 11.4477 14.0005 12 14.0005C12.5523 14.0005 13 13.5528 13 13.0005V7.00049ZM12 15.0005C11.4477 15.0005 11 15.4482 11 16.0005C11 16.5528 11.4477 17.0005 12 17.0005H12.01C12.5623 17.0005 13.01 16.5528 13.01 16.0005C13.01 15.4482 12.5623 15.0005 12.01 15.0005H12Z"
                , SvgAttr.fill "black"
                ]
                []
            ]


more : Icon
more =
    icon "more-icon" <|
        path
            [ SvgAttr.d "M6 14C5.45 14 4.97917 13.8042 4.5875 13.4125C4.19583 13.0208 4 12.55 4 12C4 11.45 4.19583 10.9792 4.5875 10.5875C4.97917 10.1958 5.45 10 6 10C6.55 10 7.02083 10.1958 7.4125 10.5875C7.80417 10.9792 8 11.45 8 12C8 12.55 7.80417 13.0208 7.4125 13.4125C7.02083 13.8042 6.55 14 6 14ZM12 14C11.45 14 10.9792 13.8042 10.5875 13.4125C10.1958 13.0208 10 12.55 10 12C10 11.45 10.1958 10.9792 10.5875 10.5875C10.9792 10.1958 11.45 10 12 10C12.55 10 13.0208 10.1958 13.4125 10.5875C13.8042 10.9792 14 11.45 14 12C14 12.55 13.8042 13.0208 13.4125 13.4125C13.0208 13.8042 12.55 14 12 14ZM18 14C17.45 14 16.9792 13.8042 16.5875 13.4125C16.1958 13.0208 16 12.55 16 12C16 11.45 16.1958 10.9792 16.5875 10.5875C16.9792 10.1958 17.45 10 18 10C18.55 10 19.0208 10.1958 19.4125 10.5875C19.8042 10.9792 20 11.45 20 12C20 12.55 19.8042 13.0208 19.4125 13.4125C19.0208 13.8042 18.55 14 18 14Z"
            ]
            []


icon : String -> Svg Never -> Icon
icon label shape =
    Icon
        { label = label
        , attributes = [ SvgAttr.viewBox "0 0 24 24" ]
        , children =
            [ shape ]
        }


copy : Icon
copy =
    icon "copy-icon" <|
        path
            [ SvgAttr.d "M5.11373 22C4.56373 22 4.09289 21.8042 3.70123 21.4125C3.30956 21.0208 3.11373 20.55 3.11373 20V7C3.11373 6.71667 3.20956 6.47917 3.40123 6.2875C3.59289 6.09583 3.83039 6 4.11373 6C4.39706 6 4.63456 6.09583 4.82623 6.2875C5.01789 6.47917 5.11373 6.71667 5.11373 7V20H15.1137C15.3971 20 15.6346 20.0958 15.8262 20.2875C16.0179 20.4792 16.1137 20.7167 16.1137 21C16.1137 21.2833 16.0179 21.5208 15.8262 21.7125C15.6346 21.9042 15.3971 22 15.1137 22H5.11373ZM9.11373 18C8.56373 18 8.09289 17.8042 7.70123 17.4125C7.30956 17.0208 7.11373 16.55 7.11373 16V4C7.11373 3.45 7.30956 2.97917 7.70123 2.5875C8.09289 2.19583 8.56373 2 9.11373 2H18.1137C18.6637 2 19.1346 2.19583 19.5262 2.5875C19.9179 2.97917 20.1137 3.45 20.1137 4V16C20.1137 16.55 19.9179 17.0208 19.5262 17.4125C19.1346 17.8042 18.6637 18 18.1137 18H9.11373Z"
            ]
            []


delete : Icon
delete =
    icon "delete-icon" <|
        path
            [ SvgAttr.d "M7 21C6.45 21 5.97917 20.8042 5.5875 20.4125C5.19583 20.0208 5 19.55 5 19V6C4.71667 6 4.47917 5.90417 4.2875 5.7125C4.09583 5.52083 4 5.28333 4 5C4 4.71667 4.09583 4.47917 4.2875 4.2875C4.47917 4.09583 4.71667 4 5 4H9C9 3.71667 9.09583 3.47917 9.2875 3.2875C9.47917 3.09583 9.71667 3 10 3H14C14.2833 3 14.5208 3.09583 14.7125 3.2875C14.9042 3.47917 15 3.71667 15 4H19C19.2833 4 19.5208 4.09583 19.7125 4.2875C19.9042 4.47917 20 4.71667 20 5C20 5.28333 19.9042 5.52083 19.7125 5.7125C19.5208 5.90417 19.2833 6 19 6V19C19 19.55 18.8042 20.0208 18.4125 20.4125C18.0208 20.8042 17.55 21 17 21H7ZM9 16C9 16.2833 9.09583 16.5208 9.2875 16.7125C9.47917 16.9042 9.71667 17 10 17C10.2833 17 10.5208 16.9042 10.7125 16.7125C10.9042 16.5208 11 16.2833 11 16V9C11 8.71667 10.9042 8.47917 10.7125 8.2875C10.5208 8.09583 10.2833 8 10 8C9.71667 8 9.47917 8.09583 9.2875 8.2875C9.09583 8.47917 9 8.71667 9 9V16ZM13 16C13 16.2833 13.0958 16.5208 13.2875 16.7125C13.4792 16.9042 13.7167 17 14 17C14.2833 17 14.5208 16.9042 14.7125 16.7125C14.9042 16.5208 15 16.2833 15 16V9C15 8.71667 14.9042 8.47917 14.7125 8.2875C14.5208 8.09583 14.2833 8 14 8C13.7167 8 13.4792 8.09583 13.2875 8.2875C13.0958 8.47917 13 8.71667 13 9V16Z"
            ]
            []


farmgate : Icon
farmgate =
    icon "farmgate-icon" <|
        path
            [ SvgAttr.d "M18.7042 4.75988C18.5899 4.92645 18.5287 5.12375 18.5287 5.32579V10.1662L19.6909 10.4404C20.458 10.6214 21 11.3062 21 12.0943V16.102C21 16.2349 20.8923 16.3426 20.7594 16.3426C20.6959 16.3426 20.6354 16.3173 20.589 16.274C19.9611 15.6875 19.1317 15.3598 18.2685 15.3598C17.5631 15.3598 16.8803 15.5787 16.3115 15.9788C16.0141 16.188 15.6727 16.3426 15.3091 16.3426H14.1453C14.026 16.3426 13.9293 16.2459 13.9293 16.1267C13.9202 14.8831 13.5272 13.6724 12.8035 12.6591C12.0798 11.6458 11.0606 10.8789 9.88429 10.4626C8.70796 10.0463 7.43153 10.0008 6.22832 10.3322C5.12232 10.6368 4.1501 11.4643 3.36227 12.1406C3.29203 12.2009 3.18512 12.1414 3.19897 12.0499L4.4393 3.85043C4.51327 3.36147 4.93353 3 5.42805 3H10.6798C11.0923 3 11.4625 3.25331 11.6119 3.63783L13.5933 8.7373C13.6249 8.82576 13.6781 8.90499 13.7481 8.96783C13.8181 9.03067 13.9027 9.07514 13.9943 9.09723L17.3906 9.89987V4.83925C17.3897 4.72342 17.4251 4.61021 17.4917 4.51531L18.5034 3.03959L19.4428 3.68387L18.7042 4.75988ZM5.9951 9.06483H11.4529C11.4608 9.06483 11.4684 9.0617 11.474 9.05613C11.4777 9.0524 11.4824 9.04973 11.4875 9.04839L11.5483 9.03244C11.6899 8.98169 11.8064 8.8786 11.8736 8.74457C11.9409 8.61053 11.9538 8.45583 11.9096 8.31258L10.6414 4.49731C10.6035 4.38308 10.5303 4.28368 10.4324 4.21325C10.3344 4.14282 10.2167 4.10494 10.0959 4.10499H5.9951C5.84369 4.10499 5.69849 4.1649 5.59144 4.27155C5.48438 4.3782 5.42424 4.52285 5.42424 4.67368V8.49254C5.42423 8.6437 5.48426 8.78872 5.59122 8.89595C5.69817 9.00317 5.84336 9.06388 5.9951 9.06483ZM6.98041 5.24595C6.75949 5.24595 6.58041 5.42504 6.58041 5.64595V7.52384C6.58041 7.74475 6.75949 7.92384 6.98041 7.92384H10.0186C10.2914 7.92384 10.4842 7.65675 10.3982 7.39783L9.77494 5.51995C9.72064 5.35636 9.56766 5.24595 9.3953 5.24595H6.98041ZM7.85581 11.2532C6.72482 11.2616 5.63167 11.66 4.76238 12.3809C3.89309 13.1017 3.30138 14.1003 3.08792 15.2068C2.87447 16.3133 3.05246 17.4592 3.59161 18.4497C4.13077 19.4402 4.99777 20.2139 6.04509 20.6393C7.0924 21.0647 8.25532 21.1154 9.33596 20.7829C10.4166 20.4503 11.3482 19.755 11.9722 18.8153C12.5962 17.8756 12.874 16.7495 12.7585 15.6286C12.6429 14.5078 12.1411 13.4615 11.3384 12.6677C10.8803 12.2147 10.3367 11.8565 9.73901 11.6137C9.1413 11.371 8.50127 11.2484 7.85581 11.2532ZM7.85581 18.6174C7.27804 18.6109 6.72037 18.4052 6.27763 18.0354C5.83489 17.6655 5.5344 17.1543 5.42726 16.5887C5.32011 16.0231 5.41294 15.4379 5.68994 14.9328C5.96694 14.4276 6.41102 14.0336 6.94667 13.8178C7.48232 13.602 8.07648 13.5777 8.62811 13.7489C9.17973 13.9202 9.65478 14.2766 9.97248 14.7573C10.2902 15.2381 10.4309 15.8137 10.3707 16.3862C10.3106 16.9587 10.0532 17.4927 9.64245 17.8975C9.40714 18.1291 9.1281 18.312 8.82144 18.4356C8.51478 18.5591 8.18658 18.6209 7.85581 18.6174ZM7.85942 14.7733C7.54536 14.7759 7.24189 14.8867 7.00063 15.0871C6.75938 15.2874 6.59525 15.5648 6.53618 15.8721C6.47711 16.1794 6.52674 16.4976 6.67662 16.7725C6.82651 17.0475 7.0674 17.2622 7.35829 17.3801C7.64919 17.4981 7.97212 17.512 8.27214 17.4195C8.57217 17.3269 8.83074 17.1337 9.00387 16.8727C9.17701 16.6116 9.254 16.2989 9.22175 15.9877C9.1895 15.6764 9.05 15.386 8.82699 15.1657C8.69968 15.0399 8.54863 14.9405 8.38257 14.8732C8.21651 14.8058 8.0387 14.7719 7.85942 14.7733ZM16.8426 17.0101C17.2433 16.6816 17.746 16.5017 18.2649 16.501C18.5601 16.5008 18.8524 16.5585 19.1252 16.6708C19.3979 16.7831 19.6458 16.9479 19.8547 17.1557C20.2216 17.5213 20.45 18.0022 20.5009 18.5167C20.5519 19.0312 20.4222 19.5474 20.1341 19.9773C19.8459 20.4073 19.417 20.7244 18.9205 20.8747C18.424 21.0251 17.8905 20.9993 17.4109 20.8018C16.9313 20.6042 16.5353 20.2472 16.2903 19.7915C16.0452 19.3358 15.9663 18.8095 16.0671 18.3024C16.1678 17.7952 16.4418 17.3385 16.8426 17.0101ZM17.8212 19.2811C17.9461 19.3841 18.1029 19.4408 18.2649 19.4416C18.4514 19.4421 18.6304 19.369 18.7628 19.2382C18.8777 19.1243 18.9494 18.9743 18.9657 18.8136C18.982 18.653 18.9419 18.4917 18.8523 18.3571C18.7626 18.2226 18.629 18.1232 18.474 18.0758C18.3191 18.0284 18.1524 18.036 18.0024 18.0973C17.8525 18.1585 17.7284 18.2697 17.6515 18.4118C17.5745 18.5539 17.5494 18.7182 17.5803 18.8767C17.6113 19.0352 17.6964 19.1781 17.8212 19.2811Z"
            ]
            []


distributionCenter : Icon
distributionCenter =
    icon "distribution-center-icon" <|
        path
            [ SvgAttr.d "M17.0779 21C16.9381 21 16.8038 20.9444 16.705 20.8456C16.6061 20.7467 16.5508 20.6127 16.5508 20.4729V11.9665H7.44239V20.4729C7.44239 20.6127 7.38702 20.7467 7.28816 20.8456C7.18931 20.9444 7.05507 21 6.91526 21H4.65674C4.58754 21 4.51916 20.9863 4.45523 20.9598C4.3913 20.9333 4.33318 20.8945 4.28426 20.8456C4.23535 20.7966 4.19645 20.7383 4.17001 20.6744C4.14356 20.6104 4.12998 20.5421 4.13004 20.4729V10.875C4.13012 10.7875 4.15198 10.7013 4.19365 10.6243C4.23533 10.5473 4.29555 10.4818 4.3688 10.4339L11.7083 5.634C11.7941 5.57775 11.8945 5.54778 11.9971 5.54778C12.0997 5.54778 12.1999 5.57775 12.2857 5.634L19.6252 10.4339C19.6985 10.4817 19.7586 10.5471 19.8003 10.6241C19.842 10.7011 19.864 10.7874 19.8639 10.875V20.4729C19.8639 20.6126 19.8085 20.7465 19.7097 20.8454C19.611 20.9442 19.477 20.9999 19.3372 21H17.0779ZM12.9208 21C12.8143 21 12.7121 20.9577 12.6368 20.8824C12.5615 20.8071 12.5192 20.7049 12.5192 20.5984V18.4192C12.5192 18.3127 12.5615 18.2105 12.6368 18.1352C12.7121 18.0599 12.8143 18.0176 12.9208 18.0176H15.1004C15.2069 18.0176 15.3091 18.0599 15.3844 18.1352C15.4597 18.2105 15.502 18.3127 15.502 18.4192V20.5984C15.502 20.7049 15.4597 20.8071 15.3844 20.8824C15.3091 20.9577 15.2069 21 15.1004 21H12.9208ZM8.89443 21C8.78793 21 8.68577 20.9577 8.61046 20.8824C8.53516 20.8071 8.49286 20.7049 8.49286 20.5984V18.4192C8.49286 18.3664 8.50321 18.3141 8.52341 18.2653C8.54362 18.2166 8.57334 18.1723 8.61067 18.135C8.64801 18.0977 8.69227 18.0681 8.74104 18.0479C8.78981 18.0278 8.84208 18.0175 8.89485 18.0176H11.0741C11.1268 18.0175 11.1791 18.0278 11.2279 18.0479C11.2766 18.0681 11.3209 18.0977 11.3582 18.135C11.3956 18.1723 11.4253 18.2166 11.4455 18.2653C11.4657 18.3141 11.476 18.3664 11.476 18.4192V20.5984C11.476 20.7049 11.4337 20.8071 11.3584 20.8824C11.2831 20.9577 11.181 21 11.0745 21H8.89443ZM10.9087 17.0857C10.856 17.0857 10.8037 17.0754 10.7549 17.0552C10.7062 17.035 10.6619 17.0052 10.6246 16.9679C10.5873 16.9306 10.5577 16.8863 10.5375 16.8375C10.5174 16.7888 10.5071 16.7365 10.5072 16.6837V14.5045C10.5071 14.4517 10.5174 14.3994 10.5375 14.3507C10.5577 14.3019 10.5873 14.2578 10.6246 14.2205C10.6619 14.1832 10.7062 14.1536 10.7549 14.1334C10.8037 14.1133 10.856 14.1028 10.9087 14.1029H13.088C13.1407 14.1028 13.193 14.1133 13.2418 14.1334C13.2905 14.1536 13.3348 14.183 13.3721 14.2203C13.4095 14.2576 13.4392 14.3019 13.4594 14.3507C13.4796 14.3994 13.4899 14.4517 13.4899 14.5045V16.6837C13.4899 16.7903 13.4476 16.8925 13.3723 16.9679C13.297 17.0433 13.1949 17.0856 13.0884 17.0857H10.9087ZM20.2084 9.56522L12.8659 4.75028C12.6086 4.58159 12.3077 4.49163 12 4.49163C11.6924 4.49163 11.3914 4.58159 11.1341 4.75028L3.79167 9.56522C3.63725 9.66659 3.50164 9.79402 3.39094 9.9419L3.08877 9.48675C3.011 9.36995 2.98275 9.22716 3.0103 9.08957C3.03779 8.95217 3.11849 8.83116 3.23483 8.75307L11.7075 3.08873C11.794 3.03064 11.896 2.99974 12.0002 3C12.1043 3 12.2061 3.03089 12.2926 3.08873L20.7652 8.75307C20.8817 8.83102 20.9624 8.9521 20.9898 9.08957C21.0172 9.22716 20.989 9.36991 20.9113 9.48675L20.6087 9.9419C20.4973 9.79361 20.3607 9.66614 20.205 9.56522H20.2084Z"
            ]
            []


store : Icon
store =
    icon "store-icon" <|
        path
            [ SvgAttr.d "M19.6032 12.0536V20.5536C19.6032 20.672 19.5561 20.7855 19.4724 20.8692C19.3887 20.953 19.2751 21 19.1567 21H11.1051V14.3001C11.1051 14.2412 11.0935 14.1828 11.0708 14.1284C11.0481 14.074 11.0149 14.0246 10.9731 13.9831C10.9312 13.9416 10.8816 13.9088 10.827 13.8866C10.7724 13.8644 10.714 13.8532 10.655 13.8537H7.07577C7.01714 13.8537 6.95908 13.8652 6.9049 13.8876C6.85073 13.9101 6.80151 13.943 6.76005 13.9844C6.71858 14.0259 6.68569 14.0751 6.66325 14.1292C6.64082 14.1834 6.62927 14.2415 6.62927 14.3001V21H4.82883C4.71041 21 4.59684 20.953 4.51311 20.8692C4.42937 20.7855 4.38233 20.672 4.38233 20.5536V12.0536H4.54437C4.86098 12.0522 5.17285 11.9766 5.4549 11.8327C5.73695 11.6889 5.98132 11.481 6.16836 11.2255C6.17764 11.2362 6.18495 11.2484 6.18996 11.2615C6.37761 11.5084 6.61998 11.7085 6.89802 11.8459C7.17606 11.9833 7.48219 12.0544 7.79235 12.0536H8.35768C8.68084 12.0539 8.99935 11.9765 9.28636 11.8281C9.57337 11.6796 9.82048 11.4643 10.0069 11.2003C10.0357 11.2363 10.0645 11.2759 10.0933 11.3083C10.303 11.543 10.5599 11.7308 10.8472 11.8592C11.1345 11.9876 11.4458 12.0539 11.7605 12.0536H12.2322C12.5469 12.0539 12.8582 11.9876 13.1455 11.8592C13.4328 11.7308 13.6898 11.543 13.8994 11.3083C13.9318 11.2723 13.9606 11.2327 13.9894 11.1967C14.1749 11.4611 14.4212 11.6769 14.7076 11.826C14.994 11.9752 15.3121 12.0532 15.635 12.0536H16.2004C16.5108 12.0537 16.817 11.982 17.095 11.8439C17.373 11.7059 17.6153 11.5053 17.8027 11.2579L17.8244 11.2255C18.0114 11.4807 18.2558 11.6883 18.5379 11.8315C18.8201 11.9747 19.1319 12.0496 19.4483 12.05L19.6032 12.0536ZM17.367 17.8679V14.3001C17.367 14.2415 17.3555 14.1834 17.3331 14.1292C17.3106 14.0751 17.2777 14.0259 17.2363 13.9844C17.1948 13.943 17.1456 13.9101 17.0914 13.8876C17.0372 13.8652 16.9792 13.8537 16.9205 13.8537H13.7986C13.7389 13.8517 13.6795 13.8619 13.6238 13.8835C13.5682 13.9051 13.5175 13.9377 13.4747 13.9794C13.432 14.0211 13.3982 14.071 13.3753 14.1261C13.3523 14.1812 13.3408 14.2404 13.3413 14.3001V17.8787C13.3422 17.9374 13.3548 17.9954 13.3784 18.0493C13.402 18.1031 13.436 18.1517 13.4786 18.1923C13.5212 18.2328 13.5714 18.2645 13.6263 18.2855C13.6813 18.3064 13.7398 18.3162 13.7986 18.3143H16.9313C17.0479 18.3115 17.1587 18.2632 17.2401 18.1798C17.3215 18.0963 17.3671 17.9844 17.367 17.8679ZM6.15755 4C5.9844 4.00042 5.81506 4.05095 5.67001 4.14551C5.52496 4.24006 5.41039 4.37458 5.34016 4.53283L3.09322 9.57306C3.01678 9.74717 2.98656 9.93806 3.00549 10.1273C3.02441 10.3165 3.09184 10.4976 3.20124 10.6531C3.31159 10.8037 3.45656 10.9254 3.6239 11.0081C3.79124 11.0908 3.97604 11.1321 4.16267 11.1283H4.54437C4.78517 11.13 5.02013 11.0543 5.21463 10.9123C5.40912 10.7704 5.55285 10.5697 5.62463 10.3399L6.65807 6.60652L7.37825 4H6.15755ZM8.31807 4L6.71569 9.73867C6.63589 10.0242 6.67258 10.3296 6.8177 10.5881C6.96283 10.8466 7.20455 11.037 7.48987 11.1175C7.58988 11.1433 7.69268 11.1566 7.79595 11.1571H8.35768C8.63431 11.1597 8.90204 11.0595 9.10895 10.8759C9.31586 10.6923 9.44722 10.4384 9.47755 10.1635L10.1581 4H8.31807ZM12.9452 4H11.0583L10.4246 9.67027C10.4067 9.85568 10.4273 10.0428 10.4849 10.2199C10.5425 10.3971 10.636 10.5605 10.7595 10.6999C10.8847 10.8416 11.0388 10.9548 11.2115 11.0318C11.3842 11.1088 11.5714 11.1479 11.7605 11.1463H12.2358C12.4249 11.1479 12.6121 11.1088 12.7848 11.0318C12.9575 10.9548 13.1117 10.8416 13.2369 10.6999C13.3618 10.5592 13.456 10.394 13.5137 10.2149C13.5713 10.0358 13.5911 9.84663 13.5717 9.65947L12.9452 4ZM15.6926 4H13.8382L14.5188 10.1635C14.5489 10.4366 14.6787 10.6889 14.8833 10.8722C15.088 11.0556 15.3531 11.157 15.6278 11.1571H16.1932C16.3398 11.1576 16.485 11.1292 16.6206 11.0736C16.7562 11.0179 16.8795 10.9361 16.9835 10.8328C17.0875 10.7295 17.1701 10.6067 17.2267 10.4715C17.2832 10.3363 17.3126 10.1912 17.313 10.0447C17.3125 9.94144 17.2992 9.83865 17.2734 9.73867L15.6926 4ZM18.6598 4.53283C18.5909 4.37432 18.4772 4.23941 18.3326 4.14473C18.188 4.05006 18.0188 3.99975 17.846 4H16.6217L17.3418 6.60652L18.3753 10.3399C18.4414 10.5754 18.5827 10.7828 18.7778 10.9303C18.9729 11.0779 19.2109 11.1576 19.4555 11.1571H19.8372C20.0217 11.1624 20.2048 11.1236 20.3714 11.0441C20.5379 10.9646 20.6831 10.8466 20.7951 10.6999C20.9068 10.5454 20.9757 10.3641 20.9946 10.1744C21.0136 9.98475 20.982 9.79341 20.9031 9.61986L18.6598 4.53283Z"
            ]
            []


factory : Icon
factory =
    icon "factory-icon" <|
        path
            [ SvgAttr.d "M18.7509 8.69321C18.6785 8.64523 18.5922 8.622 18.5052 8.62707C18.4182 8.63214 18.3353 8.66522 18.269 8.72128L14.3122 11.8866V9.19101C14.3151 9.09459 14.294 8.99893 14.2509 8.91245C14.2077 8.82597 14.1438 8.7513 14.0647 8.69501C13.9922 8.64703 13.906 8.6238 13.819 8.62887C13.732 8.63394 13.649 8.66702 13.5828 8.72308L9.14041 12.2746L8.72321 5.25144H9.15713C9.29405 5.23714 9.41985 5.17019 9.50745 5.06498C9.59505 4.95977 9.63747 4.82471 9.62557 4.68885V3.56403C9.63787 3.42793 9.59564 3.2925 9.508 3.18698C9.42035 3.08145 9.29433 3.01429 9.15713 3H4.47126C4.33392 3.01412 4.20771 3.0812 4.11992 3.18674C4.03212 3.29229 3.9898 3.42782 4.00209 3.56403V4.68885C3.9902 4.82482 4.03271 4.95998 4.12047 5.06521C4.20822 5.17044 4.3342 5.23732 4.47126 5.25144H4.90517L4.00209 20.3971C3.99147 20.5483 4.03567 20.6982 4.12674 20.82C4.16601 20.8742 4.21742 20.9187 4.27694 20.9499C4.33646 20.9811 4.40247 20.9983 4.4698 21H18.5296C18.6665 20.9857 18.7923 20.9188 18.8799 20.8135C18.9675 20.7083 19.0099 20.5733 18.998 20.4374V9.19101C19.0013 9.09432 18.9804 8.99832 18.9373 8.9115C18.8942 8.82469 18.8302 8.74971 18.7509 8.69321ZM12.4377 16.4978H10.5632V14.2482H12.4377V16.4978ZM17.1239 16.4978H15.2494V14.2482H17.1239V16.4978Z"
            ]
            []
