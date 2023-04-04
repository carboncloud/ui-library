module Ui.MillerColumns exposing
    ( Model, Content, Msg, init, setFocus, setSearch, view, update
    , Config, ListItemId, focus, root, unwrapListItemId
    )

{-| This module defines a component of a miller column layout

@docs Model, Content, Msg, init, setFocus, setSearch, view, update

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
    { treeZipper : Zipper ( ListItemId, v )
    , state : State v
    }


type alias Config msg a =
    { liftMsg : Msg -> msg, content : Content a }


{-| The content of each list item

`leftAlignedText` Takes a value of a and gives back a String that is shown to the left of each list item

`mRightAlignedText` Takes a value of a and gives back a String that is shown to the right of each list item

-}
type alias Content a =
    { leftAlignedText : a -> String
    , mRightAlignedText : Maybe (a -> String)
    }


{-| Initializes a model given a Tree of a
-}
init : Tree ( String, v ) -> Model v
init tree =
    { treeZipper = Zipper.fromTree <| Tree.map (\( k, v ) -> ( ListItemId k, v )) tree, state = Focus }



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
setSearch : List (Tree ( ListItemId, v )) -> Model v -> Model v
setSearch searchResults m =
    { m | state = Search searchResults }


{-| Get the value of the current focus
-}
focus : Model v -> ( ListItemId, v )
focus =
    Zipper.label << .treeZipper


{-| Get the value of the root
-}
root : Model v -> ( ListItemId, v )
root =
    Zipper.label << Zipper.root << .treeZipper


{-| Internal messages to update the state of the component
-}
type Msg
    = Select ListItemId
    | ScrollTo (Result Dom.Error ())


{-| Update the model of the Miller Columns
-}
update : Msg -> Model v -> ( Model v, Cmd Msg )
update msg model =
    let
        focusOn x =
            Zipper.findFromRoot ((==) x << Tuple.first) model.treeZipper |> Maybe.withDefault model.treeZipper
    in
    case msg of
        Select id ->
            ( { model
                | treeZipper = focusOn id
                , state = Focus
              }
            , Task.attempt ScrollTo <| horizontalScrollToElementInViewportOf id rootId
            )

        ScrollTo _ ->
            ( model, Cmd.none )


{-| This task will scroll an element of a specific viewport into view.
We do this by taking the difference between the x-offset of the element we want to scroll to and the x-offset of the specific viewport element relative to the main scene,
we then add to the current offset of the specific viewport.
-}
horizontalScrollToElementInViewportOf : ListItemId -> String -> Task Dom.Error ()
horizontalScrollToElementInViewportOf (ListItemId listItemId) viewportId =
    Task.map3 (\listElement viewportElement { viewport } -> (listElement.element.x - viewportElement.element.x) + viewport.x)
        (Dom.getElement listItemId)
        (Dom.getElement viewportId)
        (Dom.getViewportOf viewportId)
        |> Task.andThen (\x -> Dom.setViewportOf viewportId x 0)


rootId : String
rootId =
    "ui-tree-component"


{-| View the Miller Columns
`liftMsg` lifts the MillerColumns message to another `msg` type
`Model v` the model of the MillerColumns component
-}
view :
    Config msg v
    -> Model v
    -> Styled.Html msg
view { liftMsg, content } model =
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
            Styled.div
                [ css
                    [ Css.textOverflow Css.ellipsis
                    , Css.overflow Css.hidden
                    , Css.whiteSpace Css.normal
                    , Css.lineHeight (Css.num 1.3)
                    , Css.flex (Css.num 1)
                    , Css.width (Css.px 200)
                    ]
                ]
            <|
                case content.mRightAlignedText of
                    Nothing ->
                        [ Styled.text <| content.leftAlignedText n ]

                    Just rightAlignedText ->
                        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text <| content.leftAlignedText n ]
                        , Styled.text <| rightAlignedText n
                        ]

        viewTreeNode : Tree ( ListItemId, v ) -> Styled.Html msg
        viewTreeNode t =
            let
                node =
                    Tree.label t

                ((ListItemId id) as listItemId) =
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
                    , Css.lastChild [ Css.borderRight (Css.px 0) ]

                    -- order is important since we want this to apply for the first child even when it is the last child
                    , Css.firstChild [ Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200) ]
                    , Css.borderRight3 (Css.px 1) Css.solid (toCssColor Ui.Palette.grey200)
                    , Css.padding (Css.px 0)
                    , Css.margin (Css.px 0)
                    , Css.height (Css.px 350)
                    , Css.width (Css.px 300)
                    , scrollbarWidth Thin
                    , scrollbarColor Ui.Palette.grey300 Ui.Palette.grey100
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
            , Css.flexDirection Css.row
            , Css.maxWidth (Css.px 800)
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


{-| Opaque type of the internal state of the component.
Use [setters](#setters) to set the state.
-}
type State a
    = Focus
    | Search (List (Tree ( ListItemId, a )))


type ListItemId
    = ListItemId String


unwrapListItemId : ListItemId -> String
unwrapListItemId (ListItemId s) =
    s
