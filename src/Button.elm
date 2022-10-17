module Button exposing (..)

import Accessibility.Styled as Html
import Accessibility.Styled.Role as Role
import Border
import Color
import Css exposing (border, pct, solid)
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


type ButtonEmphasis
    = Raised
    | Ghost
    | Flat


type ButtonContent
    = Text String
    | TextAndIcon String String



-- Should this be exposed??


button : List Css.Style -> List (Html.Attribute msg) -> ButtonContent -> Html.Html msg
button customStyle attrs buttonContent =
    let
        baseStyle =
            [ Css.padding2 (rpx 10) (rpx 16)
            , Css.borderRadius (rpx 24)
            , Css.fontWeight Css.bold
            , Css.color Color.white
            , Css.focus
                [ Css.outline3 (Css.px 2) Css.solid Color.focus
                , Css.outlineOffset (Css.px 2)
                ]
            ]

        style =
            baseStyle ++ customStyle
    in
    Html.button (Attributes.css style :: attrs ++ [ Role.button ]) <|
        case buttonContent of
            Text s ->
                [ Html.text s ]

            TextAndIcon s i ->
                [ Html.img "button-icon" [ Attributes.src i ], Html.text s ]


raised : ButtonColor -> msg -> ButtonContent -> Html.Html msg
raised buttonColor onClick content =
    let
        ( bgColor, hoverColor ) =
            case buttonColor of
                Primary ->
                    ( Color.primary500, Color.primary600 )

                Secondary ->
                    ( Color.secondary500, Color.secondary600 )

                Warn ->
                    ( Color.warn500, Color.warn600 )
    in
    button
        [ Css.backgroundColor bgColor
        , shadow Shadow.Small
        , Css.hover [ Css.backgroundColor hoverColor ]
        ]
        [ Events.onClick onClick ]
        content


ghost : ButtonColor -> msg -> ButtonContent -> Html.Html msg
ghost buttonColor onClick content =
    let
        ( baseColor, hoverColor ) =
            case buttonColor of
                Primary ->
                    ( Color.primary500, Color.primary050 )

                Secondary ->
                    ( Color.secondary500, Color.secondary050 )

                Warn ->
                    ( Color.warn500, Color.warn050 )
    in
    button
        [ Css.padding2 (rpx 8) (rpx 14)
        , Css.border3 (Css.px 2) Css.solid baseColor
        , Css.boxSizing Css.borderBox
        , Css.color baseColor
        , Css.hover [ Css.backgroundColor hoverColor ]
        ]
        [ Events.onClick onClick ]
        content


flat : ButtonColor -> msg -> ButtonContent -> Html.Html msg
flat buttonColor onClick content =
    let
        ( textColor, hoverColor ) =
            case buttonColor of
                Primary ->
                    ( Color.primary500, Color.primary050 )

                Secondary ->
                    ( Color.secondary500, Color.secondary050 )

                Warn ->
                    ( Color.warn500, Color.warn050 )
    in
    button
        [ Css.color textColor
        , Css.fontWeight Css.bold
        , Css.hover [ Css.backgroundColor hoverColor ]
        ]
        [ Events.onClick onClick ]
        content
