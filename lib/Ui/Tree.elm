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


type alias Model a =
    { tree : Zipper a
    , state : State a
    }


type State a
    = Focus
    | Search String (a -> String)


type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


type Msg a
    = Select a
    | GoToParent


isFocused : Zipper a -> a -> Bool
isFocused =
    (==) << Zipper.label


hasChildren : Zipper a -> Bool
hasChildren =
    (/=) 0 << List.length << Zipper.children


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
                , Css.padding2 (Css.px 15) (Css.px 15)
                , Css.borderRadius (Css.px 5)
                , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey100 ]
                ]
                    ++ (if isSelected n then
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

        isSelected node =
            Zipper.label model.tree == node

        viewNode n =
            Styled.span [ css [ Css.display Css.inlineFlex, Css.flex Css.auto ] ] <|
                case mRightAlignedText of
                    Nothing ->
                        [ Styled.text <| leftAlignedText n ]

                    Just rightAlignedText ->
                        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text <| leftAlignedText n ]
                        , Styled.text <| rightAlignedText n
                        ]

        viewTreeNode : Tree a -> Styled.Html msg
        viewTreeNode t =
            let
                node =
                    Tree.label t
            in
            Styled.li []
                [ Styled.div
                    [ labelStyle node
                    , StyledEvents.onClick <| liftMsg (Select node)
                    ]
                  <|
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
                ]

        viewTree t =
            case ( Zipper.parent t, Zipper.children t ) of
                -- If we are on focused on a leaf we view the parent
                ( Just parent, [] ) ->
                    viewTree parent

                -- If we are focused on a node with a parent and children we show a link to the parent and the children
                ( Just _, children ) ->
                    Styled.li
                        [ labelStyle <| Zipper.label t
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

        viewSearch s searchOn =
            List.map viewTreeNode << searchTree (String.contains s << String.toLower << searchOn)
    in
    Styled.ul [ css <| Css.listStyleType Css.none :: TextStyle.toCssStyle TextStyle.body ] <|
        case model.state of
            Focus ->
                viewTree model.tree

            Search s searchOn ->
                viewSearch s searchOn (Zipper.toTree model.tree)


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
            Zipper.findFromRoot ((==) n) model.tree
                |> Maybe.withDefault model.tree
    in
    case msg of
        Select node ->
            { model | tree = selectNode node }

        GoToParent ->
            -- If we are on a leaf we want to move to the parents parent
            { model
                | state = Focus
                , tree =
                    (if List.length (Zipper.children model.tree) /= 0 then
                        Just model.tree

                     else
                        Zipper.parent model.tree
                    )
                        |> Maybe.andThen Zipper.parent
                        |> Maybe.withDefault model.tree
            }


selected : Model a -> a
selected =
    Zipper.label << .tree
