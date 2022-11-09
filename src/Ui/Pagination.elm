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
import Maybe.Extra as Maybe
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
        mkPageNumber =
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

        pageNumberButtonsCount =
            7

        siblingCount =
            6

        boundaryCount =
            5

        siblingsStart =
            max (boundaryCount + 2) <|
                min (unwrapPageNumber config.currentPage - siblingCount) (config.count - boundaryCount - siblingCount * 2 - 1)

        siblingsEnd =
            min (config.count - 1) <| max (unwrapPageNumber config.currentPage + siblingCount) (boundaryCount + siblingCount * 2 + 2)

        addViewForEachPageNumber { index, previousEllipsis } =
            let
                pageNumber =
                    index + 1

                selectedStyle =
                    if unwrapPageNumber config.currentPage /= pageNumber then
                        hoverStyle

                    else
                        Css.fontWeight Css.bold

                lessThanVisibleRange =
                    pageNumber < unwrapPageNumber config.currentPage - siblingCount

                greaterThanVisbileRange =
                    pageNumber > unwrapPageNumber config.currentPage + siblingCount

                withinRange =
                    not (lessThanVisibleRange || greaterThanVisbileRange)

                pageNumberView =
                    Just
                        ( Just <|
                            A11y.li []
                                [ A11y.button
                                    [ Events.onClick <| config.onNav (PageNumber pageNumber)
                                    , Attributes.css <|
                                        selectedStyle
                                            :: buttonStyle
                                    ]
                                    [ A11y.text <| String.fromInt pageNumber ]
                                ]
                        , { index = index + 1, previousEllipsis = False }
                        )

                hiddenRangeView =
                    Just <|
                        A11y.li []
                            [ A11y.button
                                [ Attributes.css <|
                                    selectedStyle
                                        :: buttonStyle
                                ]
                                [ A11y.text <| "..." ]
                            ]

                startPagesEnd =
                    boundaryCount + siblingCount * 2 + 1
            in
            if pageNumber > config.count then
                Nothing

            else if pageNumber == 1 || pageNumber < boundaryCount + 1 || pageNumber >= config.count - (boundaryCount - 1) || pageNumber == config.count then
                pageNumberView

            else if pageNumber <= (startPagesEnd + 1) && unwrapPageNumber config.currentPage < (startPagesEnd + 1 - siblingCount) then
                pageNumberView

            else if pageNumber >= (config.count - startPagesEnd) && unwrapPageNumber config.currentPage > (config.count - startPagesEnd + siblingCount) then
                pageNumberView

            else if withinRange then
                pageNumberView

            else if not previousEllipsis then
                Just
                    ( hiddenRangeView
                    , { index = index + 1, previousEllipsis = True }
                    )

            else
                Just
                    ( Nothing
                    , { index = index + 1, previousEllipsis = previousEllipsis }
                    )
    in
    A11y.nav (Attributes.css baseStyle :: Landmark.navigation :: attrs)
        [ A11y.ul [ Attributes.css ([ Css.displayFlex, Css.property "gap" "20px" ] ++ TextStyle.toCssStyle TextStyle.label) ] <|
            A11y.li []
                [ A11y.button
                    [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber config.currentPage - 1)
                    , Attributes.css iconButtonStyle
                    ]
                    [ Icon.toStyled Icon.chevronLeft ]
                ]
                :: (Maybe.values <| unfoldr addViewForEachPageNumber { index = 0, previousEllipsis = False })
                ++ [ A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber config.currentPage + 1)
                            , Attributes.css iconButtonStyle
                            ]
                            [ Icon.toStyled Icon.chevronRight ]
                        ]
                   ]
        ]
