module Ui.Pagination exposing
    ( view, customView
    , Model, PageNumber, initPageNumber, unwrapPageNumber
    )

{-| Defines a RadioButton component


## Types

@docs Direction


## Views

@docs view, customView

-}

import Accessibility.Styled as A11y exposing (Html)
import Accessibility.Styled.Landmark as Landmark
import Css
import Extra.A11y as CCA11y
import Extra.List as CCList
import Extra.ZipList as CCZipList
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List
import Maybe.Extra as Maybe
import Rpx exposing (rpx)
import Ui.Color as Color
import Ui.Icon as Icon
import Ui.Internal.FontFamily as FontFamily
import Ui.Internal.FontSize as FontSize
import Ui.Internal.FontWeight as FontWeight
import Ui.Internal.TextColor as TextColor
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (TextStyle(..))
import ZipList


type PageNumber
    = PageNumber Int


pageNumber : Int -> Maybe PageNumber
pageNumber i =
    if i < 1 then
        Nothing

    else
        Just <| PageNumber i


initPageNumber : PageNumber
initPageNumber =
    PageNumber 1


unwrapPageNumber : PageNumber -> Int
unwrapPageNumber (PageNumber number) =
    number


type alias Model =
    { currentPage : PageNumber
    , numberOfPages : Int
    }


{-| Return a view of a pagination view.
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
customView attrs { currentPage, numberOfPages } config =
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
            PageNumber << clamp 1 numberOfPages

        ellipsis : Html msg
        ellipsis =
            A11y.li []
                [ A11y.button
                    [ Attributes.css <| hoverStyle :: buttonStyle
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
                            ++ [ if selected then
                                    Css.fontWeight Css.bold

                                 else
                                    hoverStyle
                               ]
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
    in
    ZipList.fromList (List.range 1 numberOfPages)
        |> Maybe.map (ZipList.map PageNumber)
        |> Maybe.andThen (ZipList.goToIndex (unwrapPageNumber currentPage - 1))
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
                                [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber currentPage - 1)
                                , Attributes.css iconButtonStyle
                                ]
                                [ Icon.toStyled Icon.chevronLeft ]
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
                                    [ A11y.button
                                        [ Events.onClick <| config.onNav (mkPageNumber <| unwrapPageNumber currentPage + 1)
                                        , Attributes.css iconButtonStyle
                                        ]
                                        [ Icon.toStyled Icon.chevronRight ]
                                    ]
                               ]
                    ]
            )
