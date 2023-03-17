module Ui.Tree exposing (..)

import Browser.Dom as Dom
import Css
import Html.Styled as Styled
import Html.Styled.Attributes as StyledAttributes exposing (css)
import Html.Styled.Events as StyledEvents
import List.Extra as List
import Maybe exposing (withDefault)
import String.Extra exposing (dasherize)
import Task
import Tree as Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.TextStyle as TextStyle
import ZipList exposing (ZipList)


type alias Model a =
    { tree : Zipper a
    , state : State a
    }


type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


init : Tree a -> Model a
init tree =
    { tree = Zipper.fromTree tree, state = Focus }


focus : Model a -> Model a
focus m =
    { m | state = Focus }


search : String -> (a -> String) -> Model a -> Model a
search s searchOn m =
    { m | state = Search s searchOn }


type State a
    = Focus
    | Search String (a -> String)


type Msg a
    = Select (Tree a) String
    | Up (Tree a)
    | NoOp
    | ScrollTo String


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
                , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]
                ]
                    ++ (if isFocused model.tree n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.primary050 ]

                        else
                            []
                       )

        chevronStyle =
            css
                [ Css.width (Css.px 10)
                , Css.display Css.inlineBlock
                , Css.marginRight (Css.px 10)
                ]

        viewNode n =
            Styled.span
                [ css
                    [ Css.width (Css.px 200)
                    , Css.textOverflow Css.ellipsis
                    , Css.overflow Css.hidden
                    , Css.whiteSpace Css.noWrap
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
                case Tree.children t of
                    [] ->
                        [ viewNode node ]

                    _ ->
                        [ viewNode node
                        , Styled.span
                            [ chevronStyle
                            ]
                            [ Icon.view Icon.chevronRight ]
                        ]

        viewList onSelect children =
            case children of
                [] ->
                    Styled.span [] []

                _ ->
                    Styled.ul
                        [ css <|
                            [ Css.listStyleType Css.none
                            , Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300)
                            , Css.overflowY Css.auto
                            , Css.overflowX Css.hidden
                            , Css.padding (Css.px 0)
                            , Css.margin (Css.px 0)
                            , Css.height (Css.px 300)
                            , Css.minWidth (Css.px 250)
                            , Css.property "scrollbar-width" "thin"
                            , Css.property "scrollbar-color" "#e2e2e2ff transparent"
                            ]
                                ++ TextStyle.toCssStyle TextStyle.body
                        ]
                    <|
                        List.map (viewTreeNode onSelect) children

        viewSearch onSelect s searchOn =
            viewList onSelect << searchTree (String.contains s << String.toLower << searchOn)
    in
    Styled.div
        [ StyledAttributes.id "test0r"
        , css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            , Css.overflowX Css.scroll
            , Css.property "scrollbar-width" "thin"
            , Css.property "scrollbar-color" "#e2e2e2ff transparent"
            , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300)
            ]
        ]
    <|
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


update : Msg a -> Model a -> ( Model a, Cmd (Msg a) )
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
        Select t id ->
            let
                mNewNode =
                    selectNode <| Tree.label t
            in
            ( { model
                | tree = mNewNode |> Maybe.withDefault model.tree
                , state = Focus
              }
            , Task.attempt (\_ -> ScrollTo id) (Task.succeed True)
            )

        Up mNode ->
            ( { model
                | tree =
                    selectNode (Tree.label mNode)
                        |> Maybe.withDefault model.tree
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )

        ScrollTo id ->
            ( model
            , Dom.getViewportOf "test0r"
                |> Task.andThen (\vp -> Task.map (Tuple.pair vp) (Dom.getElement "test0r"))
                |> Task.andThen (\vpInfo -> Task.map (Tuple.pair vpInfo) (Dom.getElement (Debug.log "id" id)))
                |> Task.andThen (\( vpInfo, ele ) -> Dom.setViewportOf "test0r" (Debug.log "Delta" (Debug.log "Element" ele.element.x - Debug.log "Viewport" (Tuple.second vpInfo).element.x) + Debug.log "Viewport offset" (Tuple.first vpInfo).viewport.x) 0)
                |> Task.attempt (\_ -> NoOp)
            )


selected : Model a -> a
selected =
    Zipper.label << .tree
