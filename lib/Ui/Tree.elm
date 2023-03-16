module Ui.Tree exposing (..)

import Css
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as StyledEvents
import List.Extra as List
import Stack exposing (Stack)
import Tree as Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.TextStyle as TextStyle
import ZipList exposing (ZipList)


type alias Model a =
    { tree : Zipper a
    , left : Stack (List (Tree a))
    , state : State a
    }


type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


init : Tree a -> Model a
init tree =
    { tree = Zipper.fromTree tree, left = Stack.fromList [ Tree.children tree ], state = Focus }

search : String -> (a -> String) -> Model a -> Model a
search s searchOn m = { m | state = Search s searchOn} 
type State a
    = Focus
    | Search String (a -> String)


type Msg a
    = Select (Tree a)
    | Up (Tree a)


isFocused : Zipper a -> a -> Bool
isFocused =
    (==) << Zipper.label


hasChildren : Zipper a -> Bool
hasChildren x =
    case Zipper.children x of
        [] ->
            False

        _ ->
            True


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
                    ++ (if isFocused model.tree n then
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

        viewNode n =
            Styled.span [ css [ Css.width (Css.px 300) ] ] <|
                case mRightAlignedText of
                    Nothing ->
                        [ Styled.text <| leftAlignedText n ]

                    Just rightAlignedText ->
                        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text <| leftAlignedText n ]
                        , Styled.text <| rightAlignedText n
                        ]

        viewTreeNode : (Tree a -> Msg a) -> Tree a -> Styled.Html msg
        viewTreeNode onSelect t =
            let
                node =
                    Tree.label t
            in
            Styled.li []
                [ Styled.div
                    [ labelStyle node
                    , StyledEvents.onClick <| liftMsg <| onSelect t
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

        viewList onSelect children =
            case children of
                [] ->
                    Styled.span [] []

                _ ->
                    Styled.ul [ css <| Css.listStyleType Css.none :: Css.flexGrow (Css.num 1) :: Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300) :: TextStyle.toCssStyle TextStyle.body ] <|
                        List.map (viewTreeNode onSelect) children

        viewSearch onSelect s searchOn =
            viewList onSelect << searchTree (String.contains s << String.toLower << searchOn)
    in
    Styled.div [ css [ Css.displayFlex, Css.flexDirection Css.row, Css.overflowX Css.scroll, Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300) ] ] <|
        case model.state of
            Focus ->
                case Zipper.parent model.tree of
                    Nothing ->
                        [ viewList Select (Zipper.children model.tree) ]

                    Just p ->
                        List.reverse
                            (List.unfoldr
                                (\ct ->
                                    Maybe.map (\p_ -> ( viewList Select (Zipper.children p_), p_ ))
                                        (Zipper.parent ct)
                                )
                                p
                            )
                            ++ [ viewList Select (Zipper.children p), viewList Select (Zipper.children model.tree) ]

            -- case (Stack.toList model.left, Zipper.parent model.tree) of
            --     ([], Nothing) ->
            --         [ viewList Select (Zipper.children model.tree)]
            --     ([], Just p) ->
            --         [ viewList Select (Zipper.children p)]
            --     (x :: _, Nothing) ->
            --         [ viewList Select (Zipper.children model.tree)]
            --     (x :: _, Just p) ->
            --         [ viewList Select (Zipper.children p)]
            --     (x1 :: x2 :: _, _) ->
            --         [ viewList Up (ZipList.toList x), case (Zipper.parent model.tree, Zipper.children model.tree) of
            --             (Just p, []) ->
            --                 viewList Select (Zipper.children p)
            --             (_, children) ->
            --                 viewList Select children
            --         ]
            -- case ( Zipper.parent model.tree, Zipper.children model.tree ) of
            --     (Nothing, _) ->
            --         [ viewList Select (Zipper.children model.tree) ]
            --     (Just p, []) ->
            --         case Zipper.parent p of
            --             Just grandParent ->
            --                 [ viewList Up (Zipper.children grandParent), viewList Select (Zipper.children p) ]
            --             Nothing ->
            --                 [ viewList Select (Zipper.children p)]
            --     (Just p, children) ->
            --         [ viewList Up (Zipper.children p), viewList Select children]
            Search s searchOn ->
                [ viewSearch Select s searchOn (Zipper.toTree model.tree) ]


searchTree : (a -> Bool) -> Tree a -> List (Tree a)
searchTree pred x =
    (if pred (Tree.label x) then
        (::) x

     else
        identity
    )
    <|
        List.concatMap (searchTree pred) (Tree.children x)


depth : Zipper a -> Int
depth =
    List.sum << List.unfoldr (\x -> Maybe.map (\p -> ( 1, p )) <| Zipper.parent x)


update : Msg a -> Model a -> Model a
update msg model =
    let
        selectNode n =
            if isFocused model.tree n then
                Just model.tree

            else
                Zipper.findFromRoot ((==) n) model.tree

        -- |> Maybe.andThen (ZipList.goToFirst ((==) n << Debug.log "GOT HERE 3" Tree.label))
    in
    case msg of
        Select t ->
            let
                mNewNode =
                    selectNode <| Tree.label t

                mNewZipList =
                    -- let
                    --     diff =
                    --         case mNewNode of
                    --             Just n ->
                    --                 (Stack.size model.left + 1) - depth n
                    --             Nothing ->
                    --                 0
                    -- in
                    -- if List.length (Tree.children t) /= 0 && diff /= 0 then
                    --     mNewNode
                    --         |> Maybe.andThen Zipper.parent
                    --         |> Maybe.map Zipper.children
                    -- else
                    Nothing
            in
            { model
                | tree = mNewNode |> Maybe.withDefault model.tree
                , left =
                    Maybe.map (\newZipList -> Stack.push newZipList model.left) mNewZipList
                        |> Maybe.withDefault model.left
                , state = Focus
            }

        Up mNode ->
            { model
                | tree =
                    selectNode (Tree.label mNode)
                        |> Maybe.withDefault model.tree
                , left = Tuple.second <| Stack.pop model.left
            }



-- GoToParent ->
--     -- If we are on a leaf we want to move to the parents parent
--     { model
--         | state = Focus
--         , tree =
--             (if hasChildren model.tree then
--                 Just model.tree
--              else
--                 Zipper.parent model.tree
--             )
--                 |> Maybe.andThen Zipper.parent
--                 |> Maybe.withDefault model.tree
--     }


selected : Model a -> a
selected =
    Zipper.label << .tree
