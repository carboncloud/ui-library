module Stories.Tree exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import List.Extra as List
import Storybook.Component exposing (Component)
import Storybook.Controls
import String
import Tree exposing (tree)
import Tree.Zipper as Zipper
import Ui.SearchInput as SearchInput
import Ui.Tree as Tree


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls =
            Storybook.Controls.none
        , view = \_ -> view
        , init = init
        , update = update
        }


type alias Model =
    { searchValue : String, treeModel : Tree.Model Item }


init : Model
init =
    { searchValue = "", treeModel = defaultTreeModel }


type Msg
    = GotTreeMsg (Tree.Msg Item)
    | Search String


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            { model | treeModel = Tree.update treeMsg model.treeModel, searchValue = "" }

        Search s ->
            { model | searchValue = s, treeModel = defaultTreeModel }


view : Model -> Html Msg
view { treeModel, searchValue } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.width (Css.px 500), Css.height (Css.px 1000) ] ]
            [ SearchInput.view { onInput = Search, searchLabel = "food-category", value = searchValue, onClear = Search "" }
            , Tree.view { liftMsg = GotTreeMsg }
                { tree = treeModel.tree
                , state =
                    if List.length (String.toList searchValue) >= 2 then
                        Tree.Search searchValue .label

                    else
                        Tree.Focus
                }
                viewItem
            ]


type alias Item =
    { label : String, emission : Maybe Float }


viewItem : Tree.Content Item
viewItem =
    { leftAlignedText = .label
    , mRightAlignedText = Nothing
    }


defaultTreeModel : Tree.Model Item
defaultTreeModel =
    { state = Tree.Focus
    , tree =
        Zipper.fromTree <|
            tree { label = "Food Products", emission = Nothing }
                [ tree { label = "Fruits and Vegtables", emission = Just 1 }
                    [ tree { label = "Tomatoes", emission = Just 2 }
                        [ tree { label = "Cherry tomatoes", emission = Just 3 } []
                        , tree { label = "Crushed Tomatoes", emission = Just 4 }
                            [ tree { label = "Semi Crushed", emission = Just 5 } []
                            , tree { label = "Veryvery crushed", emission = Just 6 } []
                            ]
                        ]
                    , tree { label = "Cucumber", emission = Just 7 } []
                    ]
                , tree { label = "Meat, poultry and seafood", emission = Just 8 } []
                , tree { label = "Dairy", emission = Nothing }
                    [ tree { label = "Milk", emission = Just 10 } []
                    ]
                ]
    }
