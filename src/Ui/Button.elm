module Ui.Button exposing
    ( ButtonColor(..), ButtonEmphasis(..), ButtonContent(..)
    , view, customView
    )

{-| Defines a Button component


# Types

@docs ButtonColor, ButtonEmphasis, ButtonContent


# Views

@docs view, customView

-}

import Accessibility.Styled as A11y
import Accessibility.Styled.Role as Role
import Css exposing (border, pct, solid)
import Html.Styled as Styled exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Color as Color
import Ui.Icon as Icon exposing (Icon)
import Ui.Internal.FontFamily as FontFamily
import Ui.Internal.FontSize as FontSize
import Ui.Internal.FontWeight as FontWeight
import Ui.Internal.TextColor as TextColor
import Ui.Palette as Palette
import Ui.Shadow exposing (shadow)
import Ui.TextStyle exposing (TextStyle(..), toCssStyle)




{-| Defines the available button colors

  - `Primary`: used to get users main focus
  - `Secondary`: used as an accent to `Primary`
  - `Warn`: used to indicate a destructive and/or dangerous action

-}
type ButtonColor
    = Primary
    | Secondary
    | Warn


{-| Defines the emphasis of the button
-}
type ButtonEmphasis
    = High
    | Mid
    | Low


{-| Defins the content of the button
-}
type ButtonContent
    = Text String
    | TextWithLeftIcon String String
    | TextWithRightIcon String String
    | Icon { icon : Icon, tooltip : String }



{-| Returns a view of a button
This should be used whenever possible.
You can use `customView` if you need to
customize the button.
-}
view :
    { onClick : msg
    , color : ButtonColor
    , emphasis : ButtonEmphasis
    }
    -> ButtonContent
    -> Html msg
view { onClick, color, emphasis } =
    customView []
        { onClick = onClick
        , color = color
        , emphasis = emphasis
        }


{-| Returns a custom view of a button.
Only use this when `view` is not enough.
-}
customView :
    List (Styled.Attribute msg)
    ->
        { onClick : msg
        , color : ButtonColor
        , emphasis : ButtonEmphasis
        }
    -> ButtonContent
    -> Html msg
customView attrs { emphasis, color, onClick } content =
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
                (Events.onClick onClick :: attrs)
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
                (Events.onClick onClick :: attrs)
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
                (Events.onClick onClick :: attrs)
                content



buttonText : TextStyle
buttonText =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Small
        , weight = FontWeight.Regular
        , color = TextColor.PrimaryWhite
        }


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
                [ Css.outline3 (Css.px 2) Css.solid (Color.toCssColor Palette.focus) ]
            ]

        textButtonStyle =
            baseStyle ++ toCssStyle buttonText ++ customStyle

        iconButtonStyle =
            baseStyle ++ customStyle ++ [ Css.displayFlex, Css.borderRadius (Css.pct 100), Css.padding Css.zero, Css.width (Css.px 36), Css.height (Css.px 36) ]
    in
    case buttonContent of
        Text s ->
            A11y.button (Attributes.css textButtonStyle :: attrs ++ [ Role.button ]) [ A11y.text s ]

        TextWithLeftIcon s i ->
            A11y.button (Attributes.css textButtonStyle :: attrs ++ [ Role.button ]) [ A11y.img "button-icon" [ Attributes.src i ], A11y.text s ]

        TextWithRightIcon s i ->
            A11y.button (Attributes.css textButtonStyle :: attrs ++ [ Role.button ]) [ A11y.text s, A11y.img "button-icon" [ Attributes.src i ] ]

        Icon { icon, tooltip } ->
            A11y.button (Attributes.css iconButtonStyle :: attrs ++ [ Role.button, Attributes.title tooltip ]) [ A11y.div [ Attributes.css [ Css.margin Css.auto, Css.width (Css.px 20), Css.height (Css.px 20) ] ] [ Icon.view icon ] ]
