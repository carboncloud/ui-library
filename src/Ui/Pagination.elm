module Ui.Pagination exposing
    ( PageNumber, Model
    , mkModel
    , view, customView
    , initPageNumber, unwrapPageNumber, pageNumber
    )

{-| Defines a Pagination component


## Types

@docs PageNumber, Model


## Model

@docs mkModel


## Views

@docs view, customView


## PageNumber

@docs pageNumber, initPageNumber, unwrapPageNumber

-}

import Accessibility.Styled as A11y exposing (Html)
import Accessibility.Styled.Landmark as Landmark
import Css
import Extra.List as CCList
import Extra.ZipList as CCZipList
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List
import Maybe.Extra as Maybe
import Rpx exposing (rpx)
import Ui.Color as Color
import Ui.Icon as Icon exposing (Icon)
import Ui.Internal.FontFamily as FontFamily
import Ui.Internal.FontSize as FontSize
import Ui.Internal.FontWeight as FontWeight
import Ui.Internal.TextColor as TextColor
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (TextStyle(..))
import ZipList exposing (ZipList)


{-| An opaque type wrapper around an Int to prevent it from being set outside of the component
-}
type PageNumber
    = PageNumber Int


{-| The intial value of the page number
-}
initPageNumber : PageNumber
initPageNumber =
    PageNumber 1


{-| Unwrap the page number value
-}
unwrapPageNumber : PageNumber -> Int
unwrapPageNumber (PageNumber number) =
    number


{-| The Pagination model
-}
type alias Model =
    ZipList PageNumber


{-| Creates a model for the component
-}
mkModel :
    { numberOfPages : Int
    , currentPage : PageNumber
    }
    -> Result String Model
mkModel { numberOfPages, currentPage } =
    if numberOfPages < 1 then
        Err "Provide a value greater than zero for the number of pages."

    else
        (List.map PageNumber <| List.range 1 numberOfPages)
            |> ZipList.fromList
            |> Maybe.andThen (ZipList.goToIndex (unwrapPageNumber currentPage - 1))
            |> Result.fromMaybe "Current page number should be in the range [1,number of pages]"


{-| Creates a page number given page number that is within the range [1, number of pages]
-}
pageNumber : Int -> Int -> Result String PageNumber
pageNumber numberOfPages i =
    if i < 1 || i > numberOfPages then
        Err "Page number should be in the range [1,number of pages]"

    else
        Ok <| PageNumber i


{-| Returns a view of a pagination component.
This should be used whenever possible.
You can use `customView` if you need to
customize the button.
-}
view :
    Model
    ->
        { -- the amount of numbers shown adjacent to the selected page
          siblingCount : Int

        -- the amount of numbers shown at the far end of the range
        , boundaryCount : Int
        , onNav : PageNumber -> msg
        }
    -> Html msg
view =
    customView []


{-| Returns a custom view of a pagination component.
Only use this when `view` is not enough.
-}
customView :
    List (Attribute Never)
    -> Model
    ->
        { -- the amount of numbers shown adjacent to the selected page
          siblingCount : Int

        -- the amount of numbers shown at the far end of the range
        , boundaryCount : Int
        , onNav : PageNumber -> msg
        }
    -> Html msg
customView attrs zipList config =
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
            buttonStyle
                ++ [ Css.padding (rpx 10) ]

        ellipsis : Html msg
        ellipsis =
            A11y.li []
                [ A11y.button
                    [ Attributes.css <| buttonStyle ++ [ Css.cursor Css.default ]
                    ]
                    [ A11y.text <| "..." ]
                ]

        pageButton : Bool -> PageNumber -> Html msg
        pageButton selected pageNumber_ =
            A11y.li []
                [ A11y.button
                    [ Events.onClick <| config.onNav pageNumber_
                    , Attributes.css <|
                        buttonStyle
                            ++ TextStyle.toCssStyle
                                (TextStyle
                                    { family = FontFamily.Primary
                                    , size = FontSize.Normal
                                    , weight = FontWeight.Regular
                                    , color = TextColor.Primary
                                    }
                                )
                            ++ (if selected then
                                    [ Css.fontWeight Css.bold, Css.backgroundColor <| Color.toCssColor Palette.primary050 ]

                                else
                                    [ hoverStyle ]
                               )
                    ]
                    [ A11y.text <| String.fromInt (unwrapPageNumber pageNumber_) ]
                ]

        baseRangeLength =
            config.boundaryCount
                + config.siblingCount
                -- plus 1 to account for the ellipsis
                + 1

        leftToRightRange :
            { range : List PageNumber

            -- to compensate for when the other side is shorter
            , extraNumberOfItems : Int
            }
            -> List (Html msg)
        leftToRightRange { range, extraNumberOfItems } =
            if List.length range <= (baseRangeLength + extraNumberOfItems) then
                List.map (pageButton False) range

            else
                (List.map (pageButton False) <| List.take (config.siblingCount + extraNumberOfItems) range)
                    ++ ellipsis
                    :: (List.map (pageButton False) <| CCList.takeLast config.boundaryCount range)

        navButton : Icon -> Maybe PageNumber -> Html msg
        navButton icon mPageNumber =
            case mPageNumber of
                Just x ->
                    A11y.button
                        [ Events.onClick <| config.onNav x
                        , Attributes.css <|
                            Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]
                                :: iconButtonStyle
                                ++ []
                        ]
                        [ Icon.toStyled icon ]

                Nothing ->
                    A11y.button
                        [ Attributes.css <| iconButtonStyle ++ [ Css.cursor Css.default ] ]
                        [ Icon.toStyled (icon |> Icon.setBackground Palette.disabled) ]

        currentPage =
            ZipList.current zipList

        numberOfPages =
            ZipList.length zipList
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
                [ navButton Icon.chevronLeft (Result.toMaybe <| pageNumber numberOfPages <| unwrapPageNumber currentPage - 1)
                ]
                :: List.reverse
                    (leftToRightRange
                        { range = List.reverse <| CCZipList.getInitial zipList
                        , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| CCZipList.getTail zipList)
                        }
                    )
                ++ pageButton True (ZipList.current zipList)
                :: leftToRightRange
                    { range = CCZipList.getTail zipList
                    , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| CCZipList.getInitial zipList)
                    }
                ++ [ A11y.li []
                        [ navButton Icon.chevronRight (Result.toMaybe <| pageNumber numberOfPages <| unwrapPageNumber currentPage + 1)
                        ]
                   ]
        ]
