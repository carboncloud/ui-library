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

import Accessibility.Styled as A11y exposing (Html, span)
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
import Ui.Color as Color
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.Icon as Icon exposing (Icon)
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (FontWeight(..), TextStyle(..))
import ZipList exposing (ZipList)


{-| The Pagination model
-}
type Model a
    = Model (ZipList ( Int, a ))


{-| Creates a model for the component
-}
init : ZipList a -> Model a
init =
    Model << ZipList.indexedMap (\i x -> Tuple.pair (i + 1) x)


{-| Returns a view of a pagination component.
-}
view :
    Model a
    ->
        { -- the amount of numbers shown adjacent to the selected page
          siblingCount : Int

        -- the amount of numbers shown at the far end of the range
        , boundaryCount : Int
        , onNav : Model a -> msg
        }
    -> Html msg
view =
    customView []


{-| Returns the current page number
-}
currentPage : Model a -> ( Int, a )
currentPage (Model z) =
    ZipList.current z


{-| Go to the previous page
-}
previousPage : Model a -> Maybe (Model a)
previousPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpBackward 1 model


{-| Go to the next page
-}
nextPage : Model a -> Maybe (Model a)
nextPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpForward 1 model


{-| Set the current page
-}
setPage : Model a -> Int -> Maybe (Model a)
setPage (Model m) p =
    Maybe.map Model <| ZipList.goToIndex (p - 1) m


{-| Return the left range [1,current page - 1] of the current page
-}
getInitial : Model a -> List Int
getInitial (Model (ZipList.Zipper initial _ _)) =
    List.map Tuple.first <| List.reverse initial


{-| Return the right range [current page + 1, number of pages] of the current page
-}
getTail : Model a -> List Int
getTail (Model (ZipList.Zipper _ _ tail)) =
    List.map Tuple.first <| tail


{-| Returns a custom view of a pagination component.
Only use this when `view` is not enough.
-}
customView :
    List (Attribute Never)
    -> Model a
    ->
        { -- the amount of numbers shown adjacent to the selected page
          siblingCount : Int

        -- the amount of numbers shown at the far end of the range
        , boundaryCount : Int
        , onNav : Model a -> msg
        }
    -> Html msg
customView attrs model config =
    let
        buttonSize =
            36

        buttonStyle =
            [ Css.height (Css.px buttonSize)
            , Css.width (Css.px buttonSize)
            , Css.cursor Css.pointer
            , Css.border Css.zero
            , Css.backgroundColor Css.transparent
            , Css.property "display" "grid"
            , Css.property "place-items" "center"
            , Css.borderRadius (Css.px <| buttonSize / 2)
            ]

        hoverStyle =
            Css.hover [ Css.backgroundColor <| Color.toCssColor Palette.primary050 ]

        iconButtonStyle =
            buttonStyle
                ++ [ Css.padding (Css.px 10) ]

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

        navButton : Icon -> Maybe (Model a) -> Html msg
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
                ++ pageButton True (Tuple.first <| currentPage model)
                :: leftToRightRange
                    { range = getTail model
                    , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| getInitial model)
                    }
                ++ [ A11y.li []
                        [ navButton Icon.chevronRight (nextPage model)
                        ]
                   ]
        ]
