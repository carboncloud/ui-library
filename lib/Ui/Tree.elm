module Ui.Tree exposing (Model, Content, Msg, init, focus, search, view, update)

{-| This module defines a component of a miller column layout

@docs Model, Content, State, Msg, init, focus, search, view, update

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
import Task
import Tree as Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Icon as Icon
import Ui.Palette
import Ui.Scrollbar exposing (ScrollbarWidth(..), scrollbarColor, scrollbarWidth)
import Ui.TextStyle as TextStyle


{-| -}
type alias Model a =
    { tree : Zipper a
    , state : State a
    }


{-| -}
type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


{-| -}
type Msg a
    = Select (Tree a) String
    | ScrollTo (Result Dom.Error ())


type State a
    = Focus
    | Search String (a -> String)

{-|
-}
init : Tree a -> Model a
init tree =
    { tree = Zipper.fromTree tree, state = Focus }

{-|
-}
focus : Model a -> Model a
focus m =
    { m | state = Focus }

{-|
-}
search : String -> (a -> String) -> Model a -> Model a
search s searchOn m =
    { m | state = Search s searchOn }


rootId : String
rootId =
    "ui-tree-component"


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
                , Css.hover [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]
                ]
                    ++ (if Zipper.isFocused model.tree n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.grey300 ]

                        else if Zipper.isParent model.tree n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.grey200 ]

                        else
                            []
                       )

        chevronStyle =
            css
                [ Css.width (Css.px 10)
                , Css.display Css.inlineBlock
                , Css.marginRight (Css.px 10)
                , Css.fill <| toCssColor Ui.Palette.grey800
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
                        [ chevronStyle
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
                    , Css.firstChild [ Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300) ]
                    , Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300)
                    , Css.overflowY Css.auto
                    , Css.overflowX Css.hidden
                    , Css.padding (Css.px 0)
                    , Css.margin (Css.px 0)
                    , Css.height (Css.px 300)
                    , Css.minWidth (Css.px 250)
                    , Css.maxWidth (Css.px 350)
                    , scrollbarWidth Thin
                    , scrollbarColor Ui.Palette.grey300 (Color.rgba 0 0 0 0)
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
            , Css.borderRadius (Css.px 10)
            , Css.overflowX Css.scroll
            , scrollbarWidth Thin
            , scrollbarColor Ui.Palette.grey300 (Color.rgba 0 0 0 0)
            , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey300)
            ]
        ]
    <|
        case model.state of
            Focus ->
                List.reverse <|
                    List.unfoldr
                        (\ct ->
                            Maybe.map (\p -> ( viewList Select (Zipper.children p), p ))
                                (Zipper.parent ct)
                        )
                        model.tree
                        ++ (case Zipper.children model.tree of
                                [] ->
                                    []

                                children ->
                                    [ viewList Select children ]
                           )

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


update : Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update msg model =
    let
        focusOn x =
            Zipper.findFromRoot ((==) x) model.tree |> Maybe.withDefault model.tree
    in
    case msg of
        Select t id ->
            ( { model
                | tree = focusOn (Tree.label t)
                , state = Focus
              }
            , Dom.getViewportOf rootId
                |> Task.andThen (\vp -> Task.map (Tuple.pair vp) (Dom.getElement rootId))
                |> Task.andThen (\vpInfo -> Task.map (Tuple.pair vpInfo) (Dom.getElement id))
                |> Task.andThen (\( vpInfo, ele ) -> Dom.setViewportOf rootId ((ele.element.x - (Tuple.second vpInfo).element.x) + (Tuple.first vpInfo).viewport.x) 0)
                |> Task.attempt ScrollTo
            )

        ScrollTo _ ->
            -- TODO: Handle error
            ( model, Cmd.none )
