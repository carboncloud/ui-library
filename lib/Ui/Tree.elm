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
        viewChildren level =
            Styled.ul [ css [ Css.marginLeft <| (Css.px <| toFloat (level * 35)) ] ] << List.map (viewTree level) << Tree.children

        viewTree : Int -> Tree (Node a) -> Styled.Html msg
        viewTree level subtree =
            let
                node =
                    Tree.label subtree

                labelStyle =
                    css <|
                        [ Css.cursor Css.pointer
                        , Css.padding2 (Css.px 15) (Css.px 15)
                        , Css.borderRadius (Css.px 5)
                        , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey100 ]
                        ] ++ if Zipper.label model == node then
                                [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]
                            else []


                chevronStyle =
                    css
                        [ Css.height (Css.px 10)
                        , Css.display Css.inlineBlock
                        , Css.marginRight (Css.px 10)
                        ]
            in
            case node of
                Collapsed _ ->
                    Styled.li [  ]
                        [ Styled.div [ labelStyle, StyledEvents.onClick <| liftMsg (Expand node) ]
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Icon.view Icon.chevronRight ]
                            , Styled.text <| (showLabel <| unwrapNode node) ++ " - level " ++ String.fromInt level
                            ]
                        ]

                Expanded _ ->
                    Styled.li [ ]
                        [ Styled.div [ labelStyle,  StyledEvents.onClick <| liftMsg (Collapse node) ]
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Icon.view Icon.chevronLeft ]
                            , Styled.text <| (showLabel <| unwrapNode node) ++ " - level " ++ String.fromInt level
                            ]
                        , viewChildren (level + 1) subtree
                        ]

                Leaf _ ->
                    Styled.li [  ]
                        [ Styled.div [ labelStyle, StyledEvents.onClick <| liftMsg (Select node) ]
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Styled.text <| (showLabel <| unwrapNode node) ++ " - level " ++ String.fromInt level ]
                            ]
                        ]
    in
    viewChildren 0 (Zipper.toTree model)


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

selected : Model a -> a
selected = unwrapNode << Zipper.label

-- update : Msg a comparable -> Model a -> Model a
-- update _ _ = Debug.todo "implement"
