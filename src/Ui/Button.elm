module Ui.Button exposing (..)

import Accessibility.Styled as A11y
import Accessibility.Styled.Role as Role
import Css exposing (border, pct, solid)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Encode as JE
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.DataAttributes as DataAttributes
import Ui.Palette as Palette
import Ui.Shadow exposing (shadow)
import Ui.Text as Text
import Ui.Font as Font exposing (Font(..))
import Ui.Color as Color


-- TODO: Add custom fallback


type ButtonColor
    = Primary
    | Secondary
    | Warn


type ButtonEmphasis
    = High
    | Mid
    | Low


type ButtonContent
    = Text String
    | TextAndIcon String String


buttonText : String -> Styled.Html msg
buttonText =
    Text.view
        (Font
            { family = Font.primary
            , size = Font.normal
            , weight = Font.bold
            , color = Font.white
            }
        )


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
            High ->
                let
                    ( bgColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( Palette.primary500, Palette.primary600 )

                            Secondary ->
                                ( Palette.secondary500, Palette.secondary600 )

                            Warn ->
                                ( Palette.warn500, Palette.warn600 )
                in
                button
                    [ Css.backgroundColor <| Color.toCssColor bgColor
                    , shadow Ui.Shadow.Small
                    , Css.border Css.zero
                    , Css.color <| Color.toCssColor Palette.white
                    , Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ]
                    ]
                    (Events.onClick onClick :: List.map DataAttributes.asStyledAttribute dataAttributes)
                    content

            Mid ->
                let
                    ( baseColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( Palette.primary500, Palette.primary050 )

                            Secondary ->
                                ( Palette.secondary500, Palette.secondary050 )

                            Warn ->
                                ( Palette.warn500, Palette.warn050 )
                in
                button
                    [ Css.padding2 (rpx 8) (rpx 14)
                    , Css.border3 (Css.px 2) Css.solid <| Color.toCssColor baseColor
                    , Css.color <| Color.toCssColor baseColor
                    , Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ]
                    ]
                    (Events.onClick onClick :: List.map DataAttributes.asStyledAttribute dataAttributes)
                    content

            Low ->
                let
                    ( textColor, hoverColor ) =
                        case color of
                            Primary ->
                                ( Palette.primary500, Palette.primary050 )

                            Secondary ->
                                ( Palette.secondary500, Palette.secondary050 )

                            Warn ->
                                ( Palette.warn500, Palette.warn050 )
                in
                button
                    [ Css.color <| Color.toCssColor textColor
                    , Css.fontWeight Css.bold
                    , Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ]
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
            , Css.color <| Color.toCssColor Palette.white
            , Css.cursor Css.pointer
            , Css.focus
                [ Css.outline3 (Css.px 2) Css.solid (Color.toCssColor Palette.focus)]
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
