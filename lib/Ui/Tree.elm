module Ui.Tree exposing (..)

import Css
import Extra.Tree
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as StyledEvents
import Tree exposing (Tree(..), label, tree)
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette


type alias Model a =
    Zipper (Node a)


init : Tree a -> Model a
init =
    Zipper.root
        << Zipper.fromTree
        << Tree.restructure identity
            (\n c ->
                case c of
                    [] ->
                        tree (Leaf n) []

                    children ->
                        tree (Collapsed n) children
            )


type Node a
    = Collapsed a
    | Expanded a
    | Leaf a


unwrapNode : Node a -> a
unwrapNode n =
    case n of
        Collapsed a ->
            a

        Expanded a ->
            a

        Leaf a ->
            a


isExpanded : Node a -> Bool
isExpanded n =
    case n of
        Collapsed _ ->
            False

        Expanded _ ->
            True

        Leaf _ ->
            False


isCollapsed : Node a -> Bool
isCollapsed =
    not << isExpanded


isLeaf : Node a -> Bool
isLeaf n =
    case n of
        Collapsed _ ->
            False

        Expanded _ ->
            False

        Leaf _ ->
            True


type Msg a
    = Expand (Node a)
    | Collapse (Node a)
    | Select (Node a)
    | GoToParent



-- type Msg a comparable = Collapse comparable
--     | Expand comparable
--     | Select comparable
--     | Up (Zipper a)
--     | Down (Zipper a)

view : { viewNode : a -> Styled.Html msg, liftMsg : Msg a -> msg } -> Model a -> Styled.Html msg
view { viewNode, liftMsg } model =
    let
        labelStyle isSelected =
            css <|
                [ Css.cursor Css.pointer
                , Css.displayFlex
                , Css.padding2 (Css.px 15) (Css.px 15)
                , Css.borderRadius (Css.px 5)
                , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey100 ]
                ]
                    ++ (if isSelected then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]

                        else
                            []
                       )

        chevronStyle =
            css
                [ Css.height (Css.px 10)
                , Css.display Css.inlineBlock
                , Css.marginRight (Css.px 10)
                ]

        viewChildren level parent =
            Styled.ul [ css [ Css.marginLeft <| (Css.px <| toFloat (level * 35)) ] ] <|
                if Tree.label parent == Zipper.label (Zipper.root model) then
                    []

                else
                    [ Styled.li
                        [ labelStyle (Zipper.label model == Tree.label parent)
                        , StyledEvents.onClick <| liftMsg GoToParent
                        ]
                        [ Styled.span
                            [ chevronStyle
                            ]
                            [ Icon.view Icon.chevronLeft ]
                        , viewNode <| unwrapNode <| Tree.label parent
                        ]
                    ]
                        ++ List.map (viewTree level) (Tree.children parent)
 
        viewTree : Int -> Tree (Node a) -> Styled.Html msg
        viewTree level subtree =
            let
                node =
                    Tree.label subtree

                isSelectedNode =
                    Zipper.label model == node
            in
            case node of
                Collapsed _ ->
                    Styled.li []
                        [ Styled.div [ labelStyle isSelectedNode, StyledEvents.onClick <| liftMsg (Expand node) ]
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Icon.view Icon.chevronRight ]
                            , viewNode <| unwrapNode node
                            ]
                        ]

                Expanded _ ->
                    Styled.li []
                        [ Styled.div [ labelStyle isSelectedNode, StyledEvents.onClick <| liftMsg (Collapse node) ]
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Icon.view Icon.chevronLeft ]
                            , viewNode <| unwrapNode node
                            ]
                        , viewChildren (level + 1) subtree
                        ]

                Leaf _ ->
                    Styled.li []
                        [ Styled.div [ labelStyle isSelectedNode, StyledEvents.onClick <| liftMsg (Select node) ]
                            [ viewNode <| unwrapNode node
                            ]
                        ]

        -- We want to show the parent tree if the focused node is a leaf
        currentTree =
            if isLeaf (Zipper.label model) then
                let
                    parent =
                        Zipper.parent model |> Maybe.withDefault model
                in
                tree (Zipper.label parent) (Zipper.children parent)

            else
                tree (Zipper.label model) (Zipper.children model)
    in
    if Tree.label currentTree == Zipper.label (Zipper.root model) then
        Styled.ul [] <| List.map (viewTree 0) <| Tree.children currentTree

    else
        viewChildren 0 currentTree


update : Msg a -> Model a -> Model a
update msg model =
    let
        selectNode n =
            Zipper.findFromRoot ((==) n) model

        updateNodeWith f =
            Maybe.map (Zipper.mapLabel f)
    in
    case msg of
        Expand node ->
            selectNode node
                |> updateNodeWith (Expanded << unwrapNode)
                |> Maybe.withDefault model

        Collapse node ->
            selectNode node
                |> updateNodeWith (Collapsed << unwrapNode)
                |> Maybe.withDefault model

        Select node ->
            selectNode node
                |> Maybe.withDefault model

        GoToParent ->
            (if isLeaf <| Zipper.label model then
                Zipper.parent model

             else
                Just model
            )
                |> updateNodeWith (Collapsed << unwrapNode)
                |> Maybe.andThen Zipper.parent
                |> Maybe.withDefault model


selected : Model a -> a
selected =
    unwrapNode << Zipper.label



-- update : Msg a comparable -> Model a -> Model a
-- update _ _ = Debug.todo "implement"
