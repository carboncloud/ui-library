module Ui.Button exposing (..)

import Accessibility.Styled as A11y
import Accessibility.Styled.Role as Role
import Ui.Border
import Css exposing (border, pct, solid)
import Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Encode as JE
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Css.Palette exposing (palette)
import Ui.Shadow exposing (shadow)
import Ui.DataAttributes as DataAttributes

-- TODO: Add custom fallback

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


view :
    { onClick : msg
    , color : ButtonColor
    , emphasis : ButtonEmphasis
    }
    -> ButtonContent
    -> Html msg
view { onClick, color, emphasis } =
    viewWithDataAttributes
        { onClick = onClick
        , color = color
        , emphasis = emphasis
        , dataAttributes = []
        }


viewWithDataAttributes :
    { onClick : msg
    , color : ButtonColor
    , emphasis : ButtonEmphasis
    , dataAttributes : List ( String, JE.Value )
    }
    -> ButtonContent
    -> Html msg
viewWithDataAttributes { emphasis, color, onClick, dataAttributes } content =
    A11y.toUnstyled <|
        case emphasis of
            Raised ->
                let
                    ( bgColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( palette.primary500, palette.primary600 )

                            Secondary ->
                                ( palette.secondary500, palette.secondary600 )

                            Warn ->
                                ( palette.warn500, palette.warn600 )
                in
                button
                    [ Css.backgroundColor bgColor
                    , shadow Ui.Shadow.Small
                    , Css.border Css.zero
                    , Css.color palette.white
                    , Css.hover [ Css.backgroundColor hoverColor ]
                    ]
                    (Events.onClick onClick :: List.map DataAttributes.asStyledAttribute dataAttributes)
                    content

            Ghost ->
                let
                    ( baseColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( palette.primary500, palette.primary050 )

                            Secondary ->
                                ( palette.secondary500, palette.secondary050 )

                            Warn ->
                                ( palette.warn500, palette.warn050 )
                in
                button
                    [ Css.padding2 (rpx 8) (rpx 14)
                    , Css.border3 (Css.px 2) Css.solid baseColor
                    , Css.boxSizing Css.borderBox
                    , Css.color baseColor
                    , Css.hover [ Css.backgroundColor hoverColor ]
                    ]
                    (Events.onClick onClick :: List.map DataAttributes.asStyledAttribute dataAttributes)
                    content

            Flat ->
                let
                    ( textColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( palette.primary500, palette.primary050 )

                            Secondary ->
                                ( palette.secondary500, palette.secondary050 )

                            Warn ->
                                ( palette.warn500, palette.warn050 )
                in
                button
                    [ Css.color textColor
                    , Css.fontWeight Css.bold
                    , Css.hover [ Css.backgroundColor hoverColor ]
                    ]
                    (Events.onClick onClick :: List.map DataAttributes.asStyledAttribute dataAttributes)
                    content


button : List Css.Style -> List (A11y.Attribute msg) -> ButtonContent -> A11y.Html msg
button customStyle attrs buttonContent =
    let
        baseStyle =
            [ Css.border Css.zero
            , Css.backgroundColor Css.transparent
            , Css.padding2 (rpx 10) (rpx 16)
            , Css.borderRadius (rpx 24)
            , Css.fontWeight Css.bold
            , Css.color palette.white
            , Css.cursor Css.pointer
            , Css.focus
                [ Css.outline3 (Css.px 2) Css.solid palette.focus
                , Css.outlineOffset (Css.px 2)
                ]
            ]

        style =
            baseStyle ++ customStyle
    in
    A11y.button (Attributes.css style :: attrs ++ [ Role.button ]) <|
        case buttonContent of
            Text s ->
                [ A11y.text s ]

            TextAndIcon s i ->
                [ A11y.img "button-icon" [ Attributes.src i ], A11y.text s ]
