module Ui.Pagination exposing
    ( Model
    , init, currentPage, previousPage, nextPage, setPage, getTail, getInitial
    , view, customView
    )

{-| Defines a Pagination component


## Types

@docs Model


## Model

@docs init, currentPage, previousPage, nextPage, setPage, getTail, getInitial


## Views

@docs view, customView

-}

import Accessibility.Styled as A11y exposing (Html)
import Accessibility.Styled.Landmark as Landmark
import Css
import Extra.A11y as CCA11y
import Extra.List as CCList
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List
import List.Extra as List
import Maybe.Extra as Maybe
import Rpx exposing (rpx)
import Ui.Color as Color
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.Icon as Icon exposing (Icon)
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (FontWeight(..), TextStyle(..))
import ZipList exposing (ZipList)


{-| The Pagination model
-}
type Model
    = Model (ZipList Int)


{-| Creates a model for the component
-}
init : Int -> Int -> Result String Model
init numberOfPages currentPage_ =
    if numberOfPages < 1 then
        Err "Provide a value greater than zero for the number of pages."

    else
        List.range 1 numberOfPages
            |> ZipList.fromList
            |> Maybe.andThen (ZipList.goToIndex (currentPage_ - 1))
            |> Maybe.map Model
            |> Result.fromMaybe "Current page number should be in the range [1,number of pages]"


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
        , onNav : Model -> msg
        }
    -> Html msg
view =
    customView []


{-| Returns the current page number
-}
currentPage : Model -> Int
currentPage (Model (ZipList.Zipper _ current _)) =
    current


{-| Go to the previous page
-}
previousPage : Model -> Maybe Model
previousPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpBackward 1 model


{-| Go to the next page
-}
nextPage : Model -> Maybe Model
nextPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpForward 1 model


{-| Set the current page
-}
setPage : Model -> Int -> Maybe Model
setPage (Model m) p =
    Maybe.map Model <| ZipList.goToIndex (p - 1) m


{-| Return the left range [1,current page - 1] of the current page
-}
getInitial : Model -> List Int
getInitial (Model (ZipList.Zipper initial _ _)) =
    List.reverse initial


{-| Return the right range [current page + 1, number of pages] of the current page
-}
getTail : Model -> List Int
getTail (Model (ZipList.Zipper _ _ tail)) =
    tail


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
        , onNav : Model -> msg
        }
    -> Html msg
customView attrs model config =
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

        pageButton : Bool -> Int -> Html msg
        pageButton selected pageNumber_ =
            CCA11y.whenJust (setPage model pageNumber_) <|
                \newModel ->
                    A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav newModel
                            , Attributes.css <|
                                buttonStyle
                                    ++ toCssStyle
                                        (TextStyle
                                            { family = TextStyle.sansSerifFamilies
                                            , size = 16
                                            , weight = Normal
                                            , color = TextStyle.primaryColor
                                            , lineHeight = 1.0
                                            }
                                        )
                                    ++ (if selected then
                                            [ Css.fontWeight Css.bold, Css.backgroundColor <| Color.toCssColor Palette.primary050 ]

                                        else
                                            [ hoverStyle ]
                                       )
                            ]
                            [ A11y.text <| String.fromInt pageNumber_ ]
                        ]

        baseRangeLength =
            config.boundaryCount
                + config.siblingCount
                -- plus 1 to account for the ellipsis
                + 1

        leftToRightRange :
            { range : List Int

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

        navButton : Icon -> Maybe Model -> Html msg
        navButton icon nextModel =
            case nextModel of
                Just x ->
                    A11y.button
                        [ Events.onClick <| config.onNav x
                        , Attributes.css <|
                            Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]
                                :: iconButtonStyle
                                ++ []
                        ]
                        [ Icon.view icon ]

                Nothing ->
                    A11y.button
                        [ Attributes.css <| iconButtonStyle ++ [ Css.cursor Css.default ] ]
                        [ Icon.view (icon |> Icon.setFill Palette.disabled) ]
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
                [ navButton Icon.chevronLeft (previousPage model)
                ]
                :: List.reverse
                    (leftToRightRange
                        { range = List.reverse <| getInitial model
                        , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| getTail model)
                        }
                    )
                ++ pageButton True (currentPage model)
                :: leftToRightRange
                    { range = getTail model
                    , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| getInitial model)
                    }
                ++ [ A11y.li []
                        [ navButton Icon.chevronRight (nextPage model)
                        ]
                   ]
        ]
