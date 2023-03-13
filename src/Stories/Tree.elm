module Stories.Tree exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import List.Extra as List
import Storybook.Component exposing (Component)
import Storybook.Controls
import String exposing (contains, toLower)
import Tree exposing (Tree, tree)
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
    { searchValue = "", treeModel = Tree.init Tree.Collapsed defaultTreeModel }


type Msg
    = GotTreeMsg (Tree.Msg Item)
    | Search String


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            { model | treeModel = Tree.update treeMsg model.treeModel }

        Search s ->
            if List.length (String.toList s) >= 2 then
                { model
                    | searchValue = s
                    , treeModel =
                        searchTree (contains (toLower s) << toLower << .label) (Tree.map Tree.unwrapNode <| Zipper.toTree model.treeModel)
                            |> Maybe.map (Tree.init Tree.Expanded)
                            |> Maybe.withDefault (Tree.init Tree.Collapsed defaultTreeModel)
                }
            else
                { model | searchValue = s,  treeModel = Tree.init Tree.Collapsed defaultTreeModel}


view : Model -> Html Msg
view { treeModel, searchValue } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.width (Css.px 500), Css.height (Css.px 1000) ] ]
            [ SearchInput.view { onInput = Search, searchLabel = "food-category", value = searchValue }
            , Tree.view { liftMsg = GotTreeMsg, viewNode = viewItem } treeModel
            , Styled.text <| "Selected: " ++ (Tree.selected treeModel).label
            , Styled.div []
                [ case (Tree.selected treeModel).emission of
                    Just _ ->
                        Styled.text "Valid ingredient selection"

                    Nothing ->
                        Styled.text "Not a valid ingredient selection"
                ]
            ]


searchTree : (a -> Bool) -> Tree a -> Maybe (Tree a)
searchTree pred x =
    let
        label =
            Tree.label x
    in
    if List.length (Tree.children x) == 0 then
        if pred label then
            Just x

        else
            Nothing

    else if List.any pred <| Tree.flatten x then
        Just <| tree (Tree.label x) (mapMaybe (searchTree pred) <| Tree.children x)

    else
        Nothing


{-| Map with a partial function and only keep Justs
-}
mapMaybe : (a -> Maybe b) -> List a -> List b
mapMaybe tryMap list =
    case list of
        a :: as_ ->
            case tryMap a of
                Just a2 ->
                    a2 :: mapMaybe tryMap as_

                Nothing ->
                    mapMaybe tryMap as_

        [] ->
            []


type alias Item =
    { label : String, emission : Maybe Float }


viewItem : Item -> Styled.Html msg
viewItem { label, emission } =
    Styled.span [ css [ Css.display Css.inlineFlex, Css.flex Css.auto ] ] <|
        case emission of
            Just e ->
                [ Styled.span [ css [ Css.flexGrow (Css.num 1) ] ] [ Styled.text label ]
                , Styled.text <| String.fromFloat e
                ]

            Nothing ->
                [ Styled.text label ]


defaultTreeModel : Tree Item
defaultTreeModel =
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
