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
import Extra.A11y as CCA11y
import Extra.List as CCList
import Extra.Nonempty as CCNonempty
import Extra.ZipList as CCZipList
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List exposing (maximum)
import List.Extra exposing (unfoldr)
import List.Nonempty as Nonempty exposing (Nonempty)
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
import ZipList


{-| Defines the NavAction
-}
type PageNumber
    = PageNumber Int


init : PageNumber
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
    customView2 []


unwrapPageNumber : PageNumber -> Int
unwrapPageNumber (PageNumber number) =
    number


type HorizontalDirection
    = Left
    | Right


customView2 :
    List (Attribute Never)
    ->
        { currentPage : PageNumber
        , count : Int
        , onNav : PageNumber -> msg
        }
    -> Html msg
customView2 attrs config =
    let
        buttonSize =
            36

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

        mkPageNumber =
            PageNumber << clamp 1 config.count

        ellipsis : Html msg
        ellipsis =
            A11y.li []
                [ A11y.button
                    [ Attributes.css <| hoverStyle :: buttonStyle
                    ]
                    [ A11y.text <| "..." ]
                ]

        pageButton :
            { selected : Bool
            , pageNumber : PageNumber
            }
            -> Html msg
        pageButton { selected, pageNumber } =
            A11y.li []
                [ A11y.button
                    [ Events.onClick <| config.onNav pageNumber
                    , Attributes.css <|
                        buttonStyle
                            ++ TextStyle.toCssStyle pageNumberStyle
                            ++ [ if selected then
                                    Css.fontWeight Css.bold

                                 else
                                    hoverStyle
                               ]
                    ]
                    [ A11y.text <| String.fromInt (unwrapPageNumber pageNumber) ]
                ]

        boundary =
            1

        siblings =
            2

        maxTotal =
            boundary * 2 + 1 + siblings * 2

        placeholderRangeLength =
            (maxTotal - 1) // 2

        viewRange :
            { range : List PageNumber
            , ellipsisDirection : HorizontalDirection
            , elementCapacity : Int -- includes the ellipsis
            }
            -> List (Html msg)
        viewRange { range, ellipsisDirection, elementCapacity } =
            if List.length range <= elementCapacity then
                List.map (\pn -> pageButton { selected = False, pageNumber = pn }) range

            else
                case ellipsisDirection of
                    Left ->
                        case Nonempty.fromList range of
                            Just ne ->
                                pageButton { selected = False, pageNumber = Nonempty.head ne }
                                    :: ellipsis
                                    :: (List.map (\pn -> pageButton { selected = False, pageNumber = pn }) <| CCList.takeLast (elementCapacity - 1) <| Nonempty.tail ne)

                            Nothing ->
                                []

                    Right ->
                        case Nonempty.fromList range of
                            Just ne ->
                                (List.map (\pn -> pageButton { selected = False, pageNumber = pn }) <|
                                    CCList.takeLast (elementCapacity - 2) <|
                                        Nonempty.toList <|
                                            CCNonempty.init ne
                                )
                                    ++ [ ellipsis
                                       , pageButton { selected = False, pageNumber = Nonempty.last ne }
                                       ]

                            Nothing ->
                                []
    in
    ZipList.fromList (List.range 1 config.count)
        |> Maybe.map (ZipList.map PageNumber)
        |> Maybe.andThen (ZipList.goToIndex (unwrapPageNumber config.currentPage - 1))
        |> CCA11y.whenJust
            (\zipList ->
                A11y.nav (Landmark.navigation :: attrs)
                    [ A11y.ul
                        [ Attributes.css
                            [ Css.displayFlex
                            , Css.property "gap" "20px"
                            , Css.listStyle Css.none
                            ]
                        ]
                      <|
                        A11y.li []
                            [ A11y.button
                                [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber config.currentPage - 1)
                                , Attributes.css iconButtonStyle
                                ]
                                [ Icon.toStyled Icon.chevronLeft ]
                            ]
                            :: viewRange { range = CCZipList.getInitial zipList, ellipsisDirection = Left, elementCapacity = placeholderRangeLength }
                            ++ pageButton { selected = True, pageNumber = ZipList.current zipList }
                            :: viewRange { range = CCZipList.getTail zipList, ellipsisDirection = Right, elementCapacity = placeholderRangeLength * 2 - (List.length <| CCZipList.getInitial zipList) }
                            ++ [ A11y.li []
                                    [ A11y.button
                                        [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber config.currentPage + 1)
                                        , Attributes.css iconButtonStyle
                                        ]
                                        [ Icon.toStyled Icon.chevronRight ]
                                    ]
                               ]
                    ]
            )


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

        siblingCount =
            5

        totalSiblingCount =
            siblingCount * 2

        boundaryCount =
            3

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
                                        buttonStyle
                                            ++ TextStyle.toCssStyle pageNumberStyle
                                            ++ [ selectedStyle ]
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

                isFirstPage =
                    pageNumber == 1

                isLastPage =
                    pageNumber == config.count

                isWithinStartBoundary =
                    pageNumber < boundaryCount + 1

                isWithinEndBoundary =
                    pageNumber >= config.count - (boundaryCount - 1)

                introPageEnd =
                    boundaryCount + totalSiblingCount + 1 + 1

                isIntroPage =
                    pageNumber <= introPageEnd

                shouldShowIntroPages =
                    unwrapPageNumber config.currentPage < introPageEnd - siblingCount

                outroPagesStart =
                    config.count - (boundaryCount + totalSiblingCount + 1)

                isOutroPage =
                    pageNumber >= outroPagesStart

                shouldShowOutroPages =
                    unwrapPageNumber config.currentPage > outroPagesStart + siblingCount
            in
            if pageNumber > config.count then
                Nothing

            else if isFirstPage || isWithinStartBoundary || isWithinEndBoundary || isLastPage then
                pageNumberView

            else if shouldShowIntroPages && isIntroPage then
                pageNumberView

            else if shouldShowOutroPages && isOutroPage then
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
    A11y.nav (Landmark.navigation :: attrs)
        [ A11y.ul
            [ Attributes.css
                [ Css.displayFlex
                , Css.property "gap" "20px"
                , Css.listStyle Css.none
                ]
            ]
          <|
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


pageNumberStyle : TextStyle
pageNumberStyle =
    TextStyle
        { family = FontFamily.Primary
        , size = FontSize.Normal
        , weight = FontWeight.Regular
        , color = TextColor.Primary
        }
