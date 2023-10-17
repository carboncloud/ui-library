module Ui.Button exposing
    ( ButtonColor(..), ButtonEmphasis(..), ButtonContent(..)
    , view, customView, iconButton, account
    )

{-| Defines a Button component


# Types

@docs ButtonColor, ButtonEmphasis, ButtonContent


# Views

@docs view, customView, iconButton, account

-}

import Accessibility.Styled as A11y
import Accessibility.Styled.Role as Role
import Color exposing (Color)
import Css
import Html.Styled as Styled exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Ui.Color as Color
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.Icon as Icon exposing (Icon)
import Ui.Palette as Palette
import Ui.Shadow exposing (shadow)
import Ui.TextStyle as TextStyle exposing (FontWeight(..), TextStyle(..))


{-| Defines the available button colors

  - `Primary`: used to get users main focus
  - `Secondary`: used as an accent to `Primary`
  - `Warn`: used to indicate a destructive and/or dangerous action
  - `Neutral`: used when little focus should be put on the button
  - `Custom`: when custom styling is needed

-}
type ButtonColor
    = Primary
    | Secondary
    | Warn
    | Neutral


{-| Defines the emphasis of the button
-}
type ButtonEmphasis
    = High
    | Mid
    | Low


{-| Defines the content of the button
-}
type ButtonContent
    = Text String
    | TextWithLeftIcon String Icon
    | TextWithRightIcon String Icon


{-| Returns a view of a button
This should be used whenever possible.
You can use `customView` if you need to
customize the button.
-}
view :
    { onClick : Maybe msg
    , color : ButtonColor
    , emphasis : ButtonEmphasis
    }
    -> ButtonContent
    -> Html msg
view { onClick, color, emphasis } =
    customView [] []
        { onClick = onClick
        , color = color
        , emphasis = emphasis
        }


{-| Returns a custom view of a button.
-}
customView :
    List Css.Style
    -> List (Styled.Attribute msg)
    ->
        { onClick : Maybe msg
        , color : ButtonColor
        , emphasis : ButtonEmphasis
        }
    -> ButtonContent
    -> Html msg
customView customStyle attrs { emphasis, color, onClick } content =
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

                        Neutral ->
                            ( Palette.black, Palette.gray800 )

                baseStyle =
                    [ Css.backgroundColor <| Color.toCssColor bgColor
                    , Css.border Css.zero
                    , Css.color <| Color.toCssColor Palette.white
                    , Css.whiteSpace Css.noWrap
                    , Css.fill <| Color.toCssColor Palette.white
                    ]

                enabledBaseStyle =
                    baseStyle ++ [ shadow Ui.Shadow.Small, Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ] ]
            in
            case onClick of
                Just _ ->
                    button
                        (enabledBaseStyle ++ customStyle)
                        attrs
                        onClick
                        content

                Nothing ->
                    button
                        (baseStyle
                            ++ [ Css.backgroundColor <| Color.toCssColor Palette.gray200
                               , Css.color <| Color.toCssColor Palette.disabled
                               , Css.cursor Css.notAllowed
                               ] ++ customStyle
                        )
                        attrs
                        onClick
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

                        Neutral ->
                            ( Palette.black, Palette.gray300 )

                baseStyle =
                    [ Css.padding2 (Css.px 8) (Css.px 14)
                    , Css.border3 (Css.px 2) Css.solid <| Color.toCssColor baseColor
                    , Css.color <| Color.toCssColor baseColor
                    , Css.whiteSpace Css.noWrap
                    , Css.fill <| Color.toCssColor baseColor
                    ]

                enabledBaseStyle =
                    baseStyle ++ [ Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ] ]
            in
            case onClick of
                Just _ ->
                    button
                        (enabledBaseStyle ++ customStyle)
                        attrs
                        onClick
                        content

                Nothing ->
                    button
                        (baseStyle
                            ++ [ Css.border3 (Css.px 2) Css.solid <| Color.toCssColor Palette.gray200
                               , Css.color <| Color.toCssColor Palette.disabled
                               , Css.cursor Css.notAllowed
                               ] ++ customStyle
                        )
                        attrs
                        onClick
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

                        Neutral ->
                            ( Palette.black, Palette.gray300 )

                baseStyle =
                    [ Css.color <| Color.toCssColor textColor
                    , Css.fontWeight (Css.int 500)
                    , Css.whiteSpace Css.noWrap
                    , Css.fill <| Color.toCssColor textColor
                    ]

                enabledBaseStyle =
                    baseStyle ++ [ Css.hover [ Css.backgroundColor <| Color.toCssColor hoverColor ] ]
            in
            case onClick of
                Just _ ->
                    button
                        (enabledBaseStyle ++ customStyle)
                        attrs
                        onClick
                        content

                Nothing ->
                    button
                        (baseStyle ++ [ Css.color <| Color.toCssColor Palette.disabled, Css.cursor Css.notAllowed ] ++ customStyle)
                        attrs
                        onClick
                        content


buttonText : TextStyle
buttonText =
    TextStyle
        { family = TextStyle.sansSerifFamilies
        , size = 14
        , weight = Normal
        , color = TextStyle.primaryWhiteColor
        , lineHeight = 1.0
        }


{-| -}
account : { picture : String, name : String, onClick : msg } -> A11y.Html msg
account { picture, name } =
    let
        accountButtonStyle =
            buttonBaseStyle
                ++ [ Css.color <| Color.toCssColor Palette.white
                   , Css.fontWeight (Css.int 500)
                   , Css.whiteSpace Css.noWrap
                   , Css.fill <| Color.toCssColor Palette.white
                   , Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.gray300 ]
                   ]
    in
    A11y.button [ Attributes.css accountButtonStyle ]
        [ A11y.text name
        , A11y.span
            [ Attributes.css
                [ Css.margin4 Css.auto Css.auto Css.auto (Css.px 10)
                , Css.displayFlex
                ]
            ]
            [ A11y.img "Profile picture"
                [ Attributes.src picture
                , Attributes.css [ Css.borderRadius (Css.pct 100), Css.width (Css.px 24), Css.margin Css.auto ]
                ]
            ]
        ]


buttonBaseStyle : List Css.Style
buttonBaseStyle =
    [ Css.displayFlex
    , Css.alignItems Css.center
    , Css.border Css.zero
    , Css.backgroundColor Css.transparent
    , Css.padding2 (Css.px 10) (Css.px 16)
    , Css.borderRadius (Css.px 24)
    , Css.fontWeight Css.bold
    , Css.color <| Color.toCssColor Palette.white
    , Css.cursor Css.pointer
    , Css.focus
        [ Css.outline3 (Css.px 1) Css.solid (Color.toCssColor Palette.focus) ]
    ]


button : List Css.Style -> List (A11y.Attribute msg) -> Maybe msg -> ButtonContent -> A11y.Html msg
button customStyle attrs mOnClick buttonContent =
    let
        textButtonStyle =
            Attributes.css <| buttonBaseStyle ++ toCssStyle buttonText ++ customStyle

        baseAttrs =
            Role.button :: onClickAttribute mOnClick ++ attrs

        textBaseAttrs =
            baseAttrs ++ [ textButtonStyle ]
    in
    case buttonContent of
        Text s ->
            A11y.button
                textBaseAttrs
                [ A11y.text s ]

        TextWithLeftIcon s i ->
            A11y.button
                textBaseAttrs
                [ A11y.span
                    [ Attributes.css
                        [ Css.height (Css.px 16)
                        , Css.width (Css.px 16)
                        , Css.margin4 Css.auto (Css.px 10) Css.auto Css.auto
                        ]
                    ]
                    [ Icon.view i ]
                , A11y.text s
                ]

        TextWithRightIcon s i ->
            A11y.button
                textBaseAttrs
                [ A11y.text s
                , A11y.span
                    [ Attributes.css
                        [ Css.height (Css.px 16)
                        , Css.width (Css.px 16)
                        , Css.margin4 Css.auto Css.auto Css.auto (Css.px 10)
                        ]
                    ]
                    [ Icon.view i ]
                ]


{-| A view of an icon button which can be useful when we have little space
-}
iconButton :
    List (Styled.Attribute msg)
    ->
        { onClick : Maybe msg
        , icon : Icon
        , tooltip : String
        }
    -> A11y.Html msg
iconButton attrs { onClick, icon, tooltip } =
    A11y.button
        (Attributes.title tooltip
            :: Attributes.css
                [ Css.padding (Css.px 7)
                , Css.width (Css.px 32)
                , Css.height (Css.px 32)
                , Css.fill (Color.toCssColor Palette.gray800)
                , Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.gray300 ]
                , Css.displayFlex
                , Css.borderRadius (Css.pct 100)
                , Css.backgroundColor Css.transparent
                , Css.border Css.zero
                , Css.cursor Css.pointer
                ]
            :: onClickAttribute onClick
            ++ attrs
        )
        [ Icon.view icon
        ]


onClickAttribute : Maybe msg -> List (A11y.Attribute msg)
onClickAttribute mOnClick =
    case mOnClick of
        Just onClick ->
            [ Events.onClick onClick, Attributes.disabled False ]

        Nothing ->
            [ Attributes.disabled True ]
