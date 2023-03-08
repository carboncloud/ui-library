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
    Zipper.fromTree
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


type Msg a
    = Expand (Node a)
    | Collapse (Node a)
    | Select (Node a)



-- type Msg a comparable = Collapse comparable
--     | Expand comparable
--     | Select comparable
--     | Up (Zipper a)
--     | Down (Zipper a)


view : { showLabel : a -> String, liftMsg : Msg a -> msg } -> Model a -> Styled.Html msg
view { showLabel, liftMsg } model =
    let
        viewTree : Int -> Tree (Node a) -> Styled.Html msg
        viewTree level subtree =
            let
                node =
                    Tree.label subtree
                
                onClick = case node of
                    Collapsed _ ->
                        Expand node
                    Expanded _ ->
                        Collapse node
                    Leaf _ ->
                        Select node
            in
            Styled.div [ css [ Css.marginLeft <| (Css.px <| toFloat (level * 10)), Css.cursor Css.pointer ] ] <|
                Styled.div
                    [ StyledEvents.onClick <| liftMsg onClick ,
                    css
                        [ Css.displayFlex
                        , Css.backgroundColor <|
                            toCssColor <|
                                if Zipper.label model == node then
                                    Ui.Palette.primary050

                                else
                                    Ui.Palette.white
                        ]
                    ]
                    [ case node of
                        Collapsed _ ->
                            Styled.span
                                [ css
                                    [ Css.height (Css.px 10)
                                    , Css.display Css.block
                                    , Css.marginRight (Css.px 10)
                                    ]
                                , StyledEvents.onClick <| liftMsg (Expand node)
                                ]
                                [ Icon.view Icon.chevronRight ]

                        Expanded _ ->
                            Styled.span
                                [ css
                                    [ Css.height (Css.px 10)
                                    , Css.display Css.block
                                    , Css.marginRight (Css.px 10)
                                    ]
                                , StyledEvents.onClick <| liftMsg (Collapse node)
                                ]
                                [ Icon.view Icon.chevronLeft ]

                        Leaf _ ->
                            Styled.span
                                [ css
                                    [ Css.height (Css.px 10)
                                    , Css.display Css.block
                                    , Css.marginRight (Css.px 10)
                                    ]
                                ]
                                []
                    , Styled.text <| (showLabel <| unwrapNode node) ++ " - level " ++ String.fromInt level
                    ]
                    :: (if isExpanded node then
                            List.map (viewTree (level + 1)) <| Tree.children subtree

                        else
                            []
                       )
    in
    viewTree 0 (Zipper.toTree model)


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



-- update : Msg a comparable -> Model a -> Model a
-- update _ _ = Debug.todo "implement"
