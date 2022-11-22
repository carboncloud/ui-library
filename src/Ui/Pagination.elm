module Ui.Pagination exposing
    ( Model
    , mkModel
    , view, customView
    , init
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
import Ui.Icon as Icon exposing (Icon)
import Ui.Internal.FontFamily as FontFamily
import Ui.Internal.FontSize as FontSize
import Ui.Internal.FontWeight as FontWeight
import Ui.Internal.TextColor as TextColor
import Ui.Palette as Palette
import Ui.TextStyle as TextStyle exposing (TextStyle(..))
import ZipList exposing (ZipList)


{-| The Pagination model
-}
type Model
    = Model (ZipList Int)


init : Model
init =
    Model <| ZipList.Zipper [4,3,2,1] 5 [6,7]


{-| Creates a model for the component
-}
mkModel : Int -> Int -> Result String Model
mkModel numberOfPages currentPage_ =
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


previousPage : Model -> Maybe Model
previousPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpBackward 1 model


nextPage : Model -> Maybe Model
nextPage (Model model) =
    Maybe.map Model <| ZipList.maybeJumpForward 1 model


currentPage : Model -> Int
currentPage (Model (ZipList.Zipper _ current _)) =
    current


setPage : Model -> Int -> Maybe Model
setPage (Model m) p =
    Maybe.map Model <| ZipList.goToIndex p m


getInitial : Model -> List Int
getInitial (Model (ZipList.Zipper initial _ _)) =
    List.reverse initial


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

        pageButton : Bool -> Int -> Html msg
        pageButton selected pageNumber_ =
            CCA11y.whenJust (setPage zipList pageNumber_) <|
                \newModel ->
                    A11y.li []
                        [ A11y.button
                            [ Events.onClick <| config.onNav newModel
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
                        [ Icon.toStyled icon ]

                Nothing ->
                    A11y.button
                        [ Attributes.css <| iconButtonStyle ++ [ Css.cursor Css.default ] ]
                        [ Icon.toStyled (icon |> Icon.setBackground Palette.disabled) ]

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
                [ navButton Icon.chevronLeft (previousPage zipList)
                ]
                :: List.reverse
                    (leftToRightRange
                        { range = List.reverse <| getInitial zipList
                        , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| getTail zipList)
                        }
                    )
                ++ pageButton True (currentPage zipList)
                :: leftToRightRange
                    { range = getTail zipList
                    , extraNumberOfItems = max 0 <| baseRangeLength - (List.length <| getInitial zipList)
                    }
                ++ [ A11y.li []
                        [ navButton Icon.chevronRight (nextPage zipList)
                        ]
                   ]
        ]
