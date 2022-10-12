module Button exposing (..)

import Accessibility.Styled as Html
import Accessibility.Styled.Role as Role
import Border
import Color
import Css exposing (pct, solid)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import Shadow exposing (shadow)


type ButtonStyle
    = ButtonStyle Css.Style


type ButtonColor
    = Primary
    | Secondary
    | Warn


color : ButtonColor -> List ButtonStyle
color buttonColor =
    let
        ( bgColor, hoverColor ) =
            case buttonColor of
                Primary ->
                    ( Color.primary500, Color.primary600 )

                Secondary ->
                    ( Color.secondary500, Color.secondary500 )

                Warn ->
                    ( Color.warn, Color.warn )
    in
    List.map ButtonStyle
        [ Css.backgroundColor bgColor
        , Css.hover [ Css.backgroundColor hoverColor ]
        ]


type ButtonContent
    = Text String
    | TextAndIcon String String



-- Should this be exposed??


button : List ButtonStyle -> List (Html.Attribute msg) -> ButtonContent -> Html.Html msg
button buttonStyle attrs buttonContent =
    let
        baseStyle =
            [ Css.padding2 (rpx 10) (rpx 16)
            , Css.borderRadius (rpx 24)
            , Css.fontWeight Css.bold
            , Css.color Color.white
            , shadow Shadow.Small
            , Css.focus
                [ Css.outline Css.zero
                , Css.boxShadow5 Css.zero Css.zero (Css.px 2) (Css.px 2) Color.focus
                ]
            ]

        customStyle =
            List.map (\(ButtonStyle attr) -> attr) buttonStyle

        style =
            baseStyle ++ customStyle
    in
    Html.button (Attributes.css style :: attrs ++ [ Role.button ]) <|
        case buttonContent of
            Text s ->
                [ Html.text s ]

            TextAndIcon s i ->
                [ Html.img "button-icon" [ Attributes.src i ], Html.text s ]


raised : List ButtonStyle -> msg -> ButtonContent -> Html.Html msg
raised attrs onClick content =
    button (color Primary ++ attrs) [ Events.onClick onClick ] content
