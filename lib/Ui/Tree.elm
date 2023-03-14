module Ui.Tree exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as StyledEvents
import List.Extra as List
import Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.TextStyle as TextStyle


type Model a
    = Focus (Zipper a)
    | Search (Zipper a) String


toZipper : Model a -> Zipper a
toZipper model =
    case model of
        Focus x ->
            x

        Search x _ ->
            x


type Msg a
    = Select a
    | GoToParent


labelStyle asd =
    css <|
        [ Css.cursor Css.pointer
        , Css.displayFlex
        , Css.padding2 (Css.px 15) (Css.px 15)
        , Css.borderRadius (Css.px 5)
        , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey100 ]
        ]
            ++ (if asd then
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


isFocused : Zipper a -> a -> Bool
isFocused =
    (==) << Zipper.label


hasChildren : Zipper a -> Bool
hasChildren =
    (/=) 0 << List.length << Zipper.children


view : { viewNode : a -> Styled.Html msg, show : a -> String, liftMsg : Msg a -> msg } -> Model a -> Styled.Html msg
view { viewNode, show, liftMsg } model =
    let
        isSelected node =
            (Zipper.label <| toZipper model) == node

        viewTreeNode : Tree a -> Styled.Html msg
        viewTreeNode t =
            let
                node =
                    Tree.label t

                content =
                    case Tree.children t of
                        [] ->
                            [ viewNode node ]

                        _ ->
                            [ Styled.span
                                [ chevronStyle
                                ]
                                [ Icon.view Icon.chevronRight ]
                            , viewNode node
                            ]
            in
            Styled.li []
                [ Styled.div [ labelStyle <| isSelected node, StyledEvents.onClick <| liftMsg (Select node) ]
                    content
                ]

        viewTree t =
            case ( Zipper.parent t, Zipper.children t ) of
                -- If we are on focused on a leaf we view the parent
                ( Just parent, [] ) ->
                    viewTree parent

                -- If we are focused on a node with a parent and children we show a link to the parent and the children
                ( Just _, children ) ->
                    Styled.li
                        [ labelStyle <| isSelected <| Zipper.label t
                        , css <| TextStyle.toCssStyle TextStyle.label
                        , StyledEvents.onClick <| liftMsg GoToParent
                        ]
                        [ Styled.span
                            [ chevronStyle
                            ]
                            [ Icon.view Icon.chevronLeft ]
                        , viewNode <| Zipper.label t
                        ]
                        :: List.map viewTreeNode children

                -- If we are focused on the root node we only show the children
                ( Nothing, children ) ->
                    List.map viewTreeNode children

        viewSearch s =
            List.map viewTreeNode << searchTree (String.contains s << String.toLower << show)
    in
    Styled.ul [ css <| TextStyle.toCssStyle TextStyle.body ] <|
        case model of
            Focus t ->
                viewTree t

            Search t s ->
                viewSearch s (Zipper.toTree t)


searchTree : (a -> Bool) -> Tree a -> List (Tree a)
searchTree pred x =
    (if pred (Tree.label x) then
        (::) x

     else
        identity
    )
    <|
        List.concatMap (searchTree pred) (Tree.children x)


update : Msg a -> Model a -> Model a
update msg model =
    let
        selectNode n =
            (Zipper.findFromRoot ((==) n) <| toZipper model)
                |> Maybe.map Focus
    in
    case msg of
        Select node ->
            selectNode node
                |> Maybe.withDefault model

        GoToParent ->
            -- If we are on a leaf we want to move to the parents parent
            (if List.length (Zipper.children <| toZipper model) /= 0 then
                Just <| toZipper model

             else
                Zipper.parent <| toZipper model
            )
                |> Maybe.andThen Zipper.parent
                |> Maybe.map Focus
                |> Maybe.withDefault model


selected : Model a -> a
selected =
    Zipper.label << toZipper
