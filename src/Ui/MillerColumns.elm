module Ui.MillerColumns exposing
    ( Config, Model, Content, Msg, init, setFocus, setSearch, view, update, NodeId, unwrapNodeId, root, focus
    , select
    )

{-| This module defines a component of a miller column layout

@docs Config, Model, Content, Msg, init, setFocus, setSearch, view, update, NodeId, unwrapNodeId, root, focus

-}

import Browser.Dom as Dom
import Css
import Extra.Tree as Tree
import Extra.Tree.Zipper as Zipper
import Html.Styled as Styled
import Html.Styled.Attributes as StyledAttributes exposing (css)
import Html.Styled.Events as StyledEvents
import List.Extra as List
import Maybe
import Maybe.Extra as Maybe
import Task exposing (Task)
import Tree as Tree exposing (Tree(..))
import Tree.Zipper as Zipper exposing (Zipper)
import Ui.Color exposing (toCssColor)
import Ui.Css.TextStyle as TextStyle
import Ui.Icon as Icon
import Ui.Palette
import Ui.Scrollbar exposing (ScrollbarWidth(..), scrollbarColor, scrollbarWidth)


{-| Model of the component

`treeZipper` the data displayed in the miller columns. The zipper has a single focus at any time.
`state` internal state of the component.

  - If the state is in `Focus` it will show the zipper in miller columns
  - If the state is in `Search` it will list all the values that contains the searched value

-}
type alias Model v =
    { treeZipper : Zipper ( NodeId, v )
    , state : State v
    }


{-| `liftMsg` "lifts" the internal messages of the component to the parent
`nodeContent` returns some Content base on a
-}
type alias Config msg a =
    { liftMsg : Msg -> msg
    , nodeContent : a -> Content
    }


{-| The content of each list item

`leftAlignedText` Takes a value of a and gives back a String that is shown to the left of each list item

`mRightAlignedText` Takes a value of a and gives back a String that is shown to the right of each list item

-}
type alias Content =
    { leftAlignedText : String
    , mTooltip : Maybe String
    , mRightAlignedText : Maybe String
    }


{-| Initializes a model given a Tree of a
-}
init : Tree ( String, v ) -> Model v
init tree =
    { treeZipper = Zipper.fromTree <| Tree.map (\( k, v ) -> ( NodeId k, v )) tree, state = Focus }



-- Setters


{-| Focus on the zipper tree
-}
setFocus : Model v -> Model v
setFocus m =
    { m | state = Focus }


{-| Display the search results of the values in the zipper
`searchValue` the value we are searching for in the tree structure
`searchOn` given a value in the tree it returns the string we want to search on with the `searchValue`
-}
setSearch : List (Tree ( NodeId, v )) -> Model v -> Model v
setSearch searchResults m =
    { m | state = Search searchResults }


select : String -> Model v -> Model v
select nodeId ({ treeZipper } as m) =
    { m | treeZipper = Zipper.findFromRoot ((==) (NodeId nodeId) << Tuple.first) treeZipper |> Maybe.withDefault treeZipper }


{-| Get the value of the current focus
-}
focus : Model v -> ( NodeId, v )
focus =
    Zipper.label << .treeZipper


{-| Get the value of the root
-}
root : Model v -> ( NodeId, v )
root =
    Zipper.label << Zipper.root << .treeZipper


{-| Internal messages to update the state of the component
-}
type Msg
    = Select NodeId
    | ScrollTo (Result Dom.Error ())


{-| Update the model of the Miller Columns
-}
update : Msg -> Model v -> ( Model v, Cmd Msg )
update msg model =
    case msg of
        Select id ->
            let
                updatedTreeZipper =
                    Zipper.findFromRoot ((==) id << Tuple.first) model.treeZipper
            in
            ( { model
                | treeZipper = updatedTreeZipper |> Maybe.withDefault model.treeZipper
                , state = Focus
              }
            , if Maybe.map Zipper.hasChildren updatedTreeZipper |> Maybe.withDefault False then
                Task.attempt ScrollTo <| horizontalScrollToElementInViewportOf id rootId

              else
                Cmd.none
            )

        ScrollTo _ ->
            ( model, Cmd.none )


{-| This task will scroll an element of a specific viewport into view.
We do this by taking the difference between the x-offset of the element we want to scroll to and the x-offset of the specific viewport element relative to the main scene,
we then add to the current offset of the specific viewport.
-}
horizontalScrollToElementInViewportOf : NodeId -> String -> Task Dom.Error ()
horizontalScrollToElementInViewportOf (NodeId listItemId) viewportId =
    Task.map3 (\listElement viewportElement { viewport } -> (listElement.element.x - viewportElement.element.x) + viewport.x)
        (Dom.getElement listItemId)
        (Dom.getElement viewportId)
        (Dom.getViewportOf viewportId)
        |> Task.andThen (\x -> Dom.setViewportOf viewportId x 0)


{-| View the Miller Columns
`liftMsg` lifts the MillerColumns message to another `msg` type
`Model v` the model of the MillerColumns component
-}
view :
    Config msg v
    -> Model v
    -> Styled.Html msg
view { liftMsg, nodeContent } model =
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
                        [ Css.backgroundColor <| toCssColor Ui.Palette.gray200 ]
                ]
                    ++ (if Zipper.isFocused model.treeZipper n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.primary600, Css.color <| toCssColor Ui.Palette.white ]

                        else if Zipper.isParent model.treeZipper n then
                            [ Css.backgroundColor <| toCssColor Ui.Palette.gray200 ]

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
                        toCssColor Ui.Palette.gray800
                ]

        viewNode n =
            let
                content =
                    nodeContent n
            in
            Styled.div
                (css
                    [ Css.textOverflow Css.ellipsis
                    , Css.overflow Css.hidden
                    , Css.whiteSpace Css.normal
                    , Css.lineHeight (Css.num 1.3)
                    , Css.flexBasis (Css.px 0)
                    , Css.flex (Css.num 1)
                    , Css.width (Css.px 200)
                    ]
                    :: (Maybe.map StyledAttributes.title content.mTooltip |> Maybe.toList)
                )
            <|
                case content.mRightAlignedText of
                    Nothing ->
                        [ Styled.text <| content.leftAlignedText ]

                    Just rightAlignedText ->
                        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text <| content.leftAlignedText ]
                        , Styled.text <| rightAlignedText
                        ]

        viewTreeNode : Tree ( NodeId, v ) -> Styled.Html msg
        viewTreeNode t =
            let
                node =
                    Tree.label t

                ((NodeId id) as listItemId) =
                    Tuple.first node
            in
            Styled.li
                [ StyledAttributes.id id
                , labelStyle node
                , StyledEvents.onClick <| liftMsg <| Select listItemId
                ]
            <|
                (viewNode <|
                    Tuple.second node
                )
                    :: (if Tree.hasChildren t then
                            [ Styled.span
                                [ chevronStyle node ]
                                [ Icon.view Icon.chevronRight ]
                            ]

                        else
                            []
                       )

        viewList children =
            Styled.ul
                [ css <|
                    [ Css.listStyleType Css.none
                    , Css.padding (Css.px 0)
                    , Css.margin (Css.px 0)
                    , Css.width (Css.px 300)
                    , Css.lastChild [ Css.borderRight (Css.px 0) ]

                    -- order is important since we want this to apply for the first child even when it is the last child
                    , Css.firstChild [ Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.gray200) ]
                    , Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.gray200)
                    ]
                        ++ TextStyle.body
                ]
            <|
                List.map viewTreeNode children
    in
    Styled.div
        [ StyledAttributes.id rootId
        , css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.border3 (Css.px 1) Css.solid (toCssColor Ui.Palette.gray200)
            , Css.overflowX Css.scroll
            , scrollbarWidth Thin
            , scrollbarColor Ui.Palette.gray300 Ui.Palette.gray100
            ]
        ]
        [ Styled.div
            [ css
                [ Css.displayFlex
                , Css.flexDirection Css.row
                , Css.maxWidth (Css.px 800)
                , Css.borderRadius (Css.px 5)
                , Css.color (toCssColor Ui.Palette.black)
                ]
            ]
          <|
            case model.state of
                Focus ->
                    List.reverse
                        (List.unfoldr
                            (\ct ->
                                Maybe.map (\p -> ( viewList (Zipper.children p), p ))
                                    (Zipper.parent ct)
                            )
                            model.treeZipper
                        )
                        ++ (case Zipper.children model.treeZipper of
                                [] ->
                                    []

                                children ->
                                    [ viewList children ]
                           )

                Search searchResults ->
                    [ viewList searchResults ]
        ]


{-| Opaque type of the internal state of the component.
Use [setters](#setters) to set the state.
-}
type State a
    = Focus
    | Search (List (Tree ( NodeId, a )))


{-| The id of a node in the tree
-}
type NodeId
    = NodeId String


{-| Get the value of a NodeId
-}
unwrapNodeId : NodeId -> String
unwrapNodeId (NodeId s) =
    s



-- Internals


rootId : String
rootId =
    "ui-tree-component"
