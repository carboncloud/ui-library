module Ui.MillerColumns exposing (Model, Content, Msg, init, setFocus, view, update, setSearch)

{-| This module defines a component of a miller column layout

@docs Model, Content, Msg, init, setFocus, setSearch, view, update

-}

import Browser.Dom as Dom
import Color
import Css
import Extra.Tree as Tree
import Extra.Tree.Zipper as Zipper
import Html.Styled as Styled
import Html.Styled.Attributes as StyledAttributes exposing (css)
import Html.Styled.Events as StyledEvents
import List.Extra as List
import Maybe
import String.Extra exposing (dasherize)
import Task exposing (Task)
import Tree as Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.Scrollbar exposing (ScrollbarWidth(..), scrollbarColor, scrollbarWidth)
import Ui.TextStyle as TextStyle


{-| Model of the component
-}
type alias Model a =
    { treeZipper : Zipper a
    , state : State a
    }


{-| The content of each list item  


`leftAlignedText` Takes a value of a and gives back a String that is shown to the left of each list item

`mRightAlignedText` Takes a value of a and gives back a String that is shown to the left of each list item
-}
type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


{-| Initializes a model given a Tree of a -}
init : Tree a -> Model a
init tree =
    { treeZipper = Zipper.fromTree tree, state = Focus }

-- Setters

{-| Focus on the zipper tree
-}
setFocus : Model a -> Model a
setFocus m =
    { m | state = Focus }


{-| Display the search results of the values in the zipper
-}
setSearch : String -> (a -> String) -> Model a -> Model a
setSearch s searchOn m =
    { m | state = Search s searchOn }


{-| Internal messages to update the state of the component
-}
type Msg a
    = Select (Tree a) String
    | ScrollTo (Result Dom.Error ())


{-| Update the model of the Miller Columns
-}
update : Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update msg model =
    let
        focusOn x =
            Zipper.findFromRoot ((==) x) model.treeZipper |> Maybe.withDefault model.treeZipper
    in
    case msg of
        Select t id ->
            ( { model
                | treeZipper = focusOn (Tree.label t)
                , state = Focus
              }
            , Task.attempt ScrollTo <| scrollToElementInViewportOf id rootId
            )

        ScrollTo _ ->
            ( model, Cmd.none )


scrollToElementInViewportOf : String -> String -> Task Dom.Error ()
scrollToElementInViewportOf elementId viewportId =
    Task.map3 (\listElement viewportElement { viewport } -> (listElement.element.x - viewportElement.element.x) + viewport.x)
        (Dom.getElement elementId)
        (Dom.getElement viewportId)
        (Dom.getViewportOf viewportId)
        |> Task.andThen (\x -> Dom.setViewportOf viewportId x 0)


rootId : String
rootId =
    "ui-tree-component"


{-| View the Miller Columns
-}
view :
    { liftMsg : Msg a -> msg
    }
    -> Model a
    -> Content a
    -> Styled.Html msg
view { liftMsg } model { leftAlignedText, mRightAlignedText } =
    let
        labelStyle n =
            css <|
                [ Css.cursor Css.pointer
                , Css.displayFlex
                , Css.padding4 (Css.px 15) (Css.px 0) (Css.px 15) (Css.px 15)
                , Css.hover <|
                    if Zipper.isFocused model.treeZipper n then
                        []

                    else
                        [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]
                ]
                    ++ (if Zipper.isFocused model.treeZipper n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.primary600, Css.color <| toCssColor Ui.Palette.white ]

                        else if Zipper.isParent model.treeZipper n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]

                        else
                            []
                       )

        chevronStyle n =
            css
                [ Css.width (Css.px 10)
                , Css.display Css.inlineBlock
                , Css.marginRight (Css.px 10)
                , Css.fill <|
                    if Zipper.isFocused model.treeZipper n then
                        toCssColor Ui.Palette.white

                    else
                        toCssColor Ui.Palette.grey800
                ]

        viewNode n =
            Styled.span
                [ css
                    [ Css.width (Css.px 200)
                    , Css.textOverflow Css.ellipsis
                    , Css.overflow Css.hidden
                    , Css.whiteSpace Css.normal
                    , Css.flex (Css.num 1)
                    , Css.lineHeight (Css.num 1.3)
                    ]
                ]
            <|
                case mRightAlignedText of
                    Nothing ->
                        [ Styled.text <| leftAlignedText n ]

                    Just rightAlignedText ->
                        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text <| leftAlignedText n ]
                        , Styled.text <| rightAlignedText n
                        ]

        viewTreeNode : (Tree a -> String -> Msg a) -> Tree a -> Styled.Html msg
        viewTreeNode onSelect t =
            let
                node =
                    Tree.label t

                id =
                    dasherize <| leftAlignedText node
            in
            Styled.li
                [ StyledAttributes.id id
                , labelStyle node
                , StyledEvents.onClick <| liftMsg <| onSelect t id
                ]
            <|
                if Tree.hasChildren t then
                    [ viewNode node
                    , Styled.span
                        [ chevronStyle node
                        ]
                        [ Icon.view Icon.chevronRight ]
                    ]

                else
                    [ viewNode node ]

        viewList onSelect children =
            Styled.ul
                [ css <|
                    [ Css.listStyleType Css.none
                    , Css.lastChild [ Css.borderRight (Css.px 0) ]

                    -- order is important since we want this to apply for the first child even when it is the last child
                    , Css.firstChild [ Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200) ]
                    , Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200)
                    , Css.overflowY Css.auto
                    , Css.overflowX Css.hidden
                    , Css.padding (Css.px 0)
                    , Css.margin (Css.px 0)
                    , Css.height (Css.px 300)
                    , Css.minWidth (Css.px 250)
                    , Css.maxWidth (Css.px 350)
                    , scrollbarWidth Thin
                    , scrollbarColor Ui.Palette.grey300 Ui.Palette.grey100
                    ]
                        ++ TextStyle.toCssStyle TextStyle.body
                ]
            <|
                List.map (viewTreeNode onSelect) children

        viewSearch onSelect s searchOn =
            viewList onSelect << searchTree (String.contains s << String.toLower << searchOn)
    in
    Styled.div
        [ StyledAttributes.id rootId
        , css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            , Css.borderRadius (Css.px 5)
            , Css.overflowX Css.scroll
            , Css.color (toCssColor Ui.Palette.black)
            , scrollbarWidth Thin
            , scrollbarColor Ui.Palette.grey300 Ui.Palette.grey100
            , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200)
            ]
        ]
    <|
        case model.state of
            Focus ->
                List.reverse
                    (List.unfoldr
                        (\ct ->
                            Maybe.map (\p -> ( viewList Select (Zipper.children p), p ))
                                (Zipper.parent ct)
                        )
                        model.treeZipper
                    )
                    ++ (case Zipper.children model.treeZipper of
                            [] ->
                                []

                            children ->
                                [ viewList Select children ]
                       )

            Search s searchOn ->
                [ viewSearch Select s searchOn (Zipper.toTree model.treeZipper) ]

{-| Opaque type of  the internal state of the component.
Use [setters](#setters) to set the state.
-}
type State a
    = Focus
    | Search String (a -> String)

-- TODO: Fix search, we should prioritize "good matches"
searchTree : (a -> Bool) -> Tree a -> List (Tree a)
searchTree pred x =
    (if pred (Tree.label x) then
        (::) x

     else
        identity
    )
    <|
        List.concatMap (searchTree pred) (Tree.children x)
