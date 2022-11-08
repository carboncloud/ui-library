module Ui.Pagination exposing (..)

{-| Defines a RadioButton component


## Types

@docs Direction


## Views

@docs view, customView

-}

import Accessibility.Styled as A11y exposing (Html)
import Accessibility.Styled.Landmark as Landmark
import Css exposing (disabled)
import Css.Transitions as Transitions
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List.Extra exposing (unfoldr)
import Rpx exposing (rpx)
import String.Extra exposing (dasherize)
import Ui.Color as Color
import Ui.Icon as Icon
import Ui.Internal.FontFamily as FontFamily
import Ui.Internal.FontSize as FontSize
import Ui.Internal.FontWeight as FontWeight
import Ui.Internal.TextColor as TextColor
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (TextStyle(..))
import Ui.Typography as Typography


{-| Defines the NavAction
-}
type PageNumber
    = PageNumber Int


init =
    PageNumber 1


{-| Return a view of a pagination view.
This should be used whenever possible.
You can use `customView` if you need to
customize the button.
-}
view :
    { currentPage : PageNumber
    , count : Int
    , onNav : PageNumber -> msg
    }
    -> Html msg
view =
    customView []


{-| Returns a custom view of a radio button group.
Only use this when `view` is not enough.
-}
customView :
    List (Attribute Never)
    ->
        { currentPage : PageNumber
        , count : Int
        , onNav : PageNumber -> msg
        }
    -> Html msg
customView attrs config =
    let
        pageNumber =
            PageNumber << clamp 1 config.count

        unwrapPageNumber (PageNumber number) =
            number

        baseStyle =
            []

        buttonStyle =
            [ Css.height (rpx buttonSize)
            , Css.width (rpx buttonSize)
            , Css.cursor Css.pointer
            , Css.border Css.zero
            , Css.backgroundColor Css.transparent
            , Css.property "display" "grid"
            , Css.property "place-items" "center"
            , Css.borderRadius (rpx <| buttonSize / 2)
            ]

        hoverStyle =
            Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]

        iconButtonStyle =
            Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]
                :: buttonStyle
                ++ [ Css.padding (rpx 10) ]

        buttonSize =
            36

        addViewForEachPageNumber i =
            let
                selectedStyle =
                    if unwrapPageNumber config.currentPage /= (i + 1) then
                        hoverStyle

                    else
                        Css.fontWeight Css.bold

                withinRange =
                    unwrapPageNumber config.currentPage - 1 <= (i + 1) && (i + 1) <= unwrapPageNumber config.currentPage + 1
            in
            if i == config.count then
                Nothing

            else if withinRange then
                Just
                    ( A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav (PageNumber <| i + 1)
                            , Attributes.css <|
                                selectedStyle
                                    :: buttonStyle
                            ]
                            [ A11y.text <| String.fromInt (i + 1) ]
                        ]
                    , i + 1
                    )

            else
                Just
                    ( A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav (PageNumber <| i + 1)
                            , Attributes.css <|
                                selectedStyle
                                    :: buttonStyle
                            ]
                            [ A11y.text "..." ]
                        ]
                    , i + 1
                    )
    in
    A11y.nav (Attributes.css baseStyle :: Landmark.navigation :: attrs)
        [ A11y.ul [ Attributes.css ([ Css.displayFlex, Css.property "gap" "20px" ] ++ TextStyle.toCssStyle TextStyle.label) ] <|
            [ A11y.li []
                [ A11y.button
                    [ Events.onClick <| config.onNav (pageNumber <| unwrapPageNumber config.currentPage - 1)
                    , Attributes.css iconButtonStyle
                    ]
                    [ Icon.toStyled Icon.chevronLeft ]
                ]
            ]
                ++ unfoldr addViewForEachPageNumber 0
                ++ [ A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav (pageNumber <| unwrapPageNumber config.currentPage + 1)
                            , Attributes.css iconButtonStyle
                            ]
                            [ Icon.toStyled Icon.chevronRight ]
                        ]
                   ]
        ]
