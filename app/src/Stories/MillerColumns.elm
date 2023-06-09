module Stories.MillerColumns exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import List.Extra as List
import Storybook.Component exposing (Component)
import Storybook.Controls
import String
import String.Extra exposing (dasherize)
import Tree exposing (Tree, tree)
import Tree.Zipper as Zipper
import Ui.Input as Input
import Ui.MillerColumns as MillerColumns


main : Component Model Msg
main =
    Storybook.Component.sandbox_
        { controls =
            Storybook.Controls.none
        , view = \_ -> view
        , init = init
        , update = update
        }


type alias Model =
    { searchValue : String, millerColumnsModel : MillerColumns.Model Item }


init : Model
init =
    let
        newTree =
            MillerColumns.init <| Tree.map (\x -> ( dasherize x.label, x )) t
    in
    { searchValue = ""
    , millerColumnsModel = newTree
    }


type Msg
    = GotTreeMsg MillerColumns.Msg
    | Search String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            let
                ( treeModel, treeCmd ) =
                    MillerColumns.update treeMsg model.millerColumnsModel
            in
            ( { model | millerColumnsModel = treeModel, searchValue = "" }, Cmd.map GotTreeMsg treeCmd )

        Search s ->
            if s /= "" then
                ( { model | searchValue = s, millerColumnsModel = MillerColumns.setSearch (searchTree (String.contains s << .label << Tuple.second) (Zipper.toTree model.millerColumnsModel.treeZipper)) model.millerColumnsModel }, Cmd.none )

            else
                ( { model | searchValue = s, millerColumnsModel = MillerColumns.setFocus model.millerColumnsModel }, Cmd.none )


searchTree : (a -> Bool) -> Tree a -> List (Tree a)
searchTree pred x =
    (if pred (Tree.label x) then
        (::) x

     else
        identity
    )
    <|
        List.concatMap (searchTree pred) (Tree.children x)


view : Model -> Html Msg
view { millerColumnsModel, searchValue } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.height (Css.px 550), Css.displayFlex, Css.flexDirection Css.column, Css.property "gap" "25px" ] ]
            [ Input.search [ css [ Css.maxWidth (Css.px 350) ] ] { onInput = Search, value = searchValue, onClear = Search "", onSearch = Nothing }
            , MillerColumns.view { liftMsg = GotTreeMsg, nodeContent = viewNode }
                (MillerColumns.select (dasherize "Meat, poultry and seafood") millerColumnsModel)
            ]


type alias Item =
    { label : String, emission : Maybe Float }


viewNode : Item -> MillerColumns.Content
viewNode item =
    { leftAlignedText = item.label
    , mRightAlignedText = Nothing
    }


t =
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
        , tree { label = "Dairy1", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Very long category that should be hard to read and maybe we should clip this in some way?", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy3", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy4", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy5", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy6", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy7", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy8", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy9", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy10", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        , tree { label = "Dairy11", emission = Nothing }
            [ tree { label = "Milk", emission = Just 10 } []
            ]
        ]
