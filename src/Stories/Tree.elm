module Stories.Tree exposing (..)

import Css
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Tree exposing (Tree, tree)
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
    { treeModel : Tree.Model Item }


init : Model
init =
    { treeModel = Tree.init defaultTreeModel }


type Msg
    = GotTreeMsg (Tree.Msg Item)


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            { model | treeModel = Tree.update treeMsg model.treeModel }


view : Model -> Html Msg
view { treeModel } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.width (Css.px 500), Css.height (Css.px 1000) ] ]
            [ Tree.view { liftMsg = GotTreeMsg, viewNode = viewItem } treeModel
            , Styled.text <| "Selected: " ++ (Tree.selected treeModel).label
            ]


type alias Item =
    { label : String, emission : Maybe Float }


viewItem : Item -> Styled.Html msg
viewItem { label, emission } = Styled.span [ css [ Css.display Css.inlineFlex, Css.width (Css.pct 100) ]] <| case emission of
    Just e ->
        [ Styled.span [ css [ Css.flexGrow (Css.num 1) ]] [ Styled.text label ], Styled.text <| String.fromFloat e]
    Nothing ->
        [ Styled.text label ]

defaultTreeModel : Tree Item
defaultTreeModel =
    tree { label = "root", emission = Nothing }
        [ tree { label = "home", emission = Just 1 }
            [ tree { label = "user1", emission = Just 2 }
                [ tree { label = "userX", emission = Just 3 } []
                , tree { label = "userY", emission = Just 4 }
                    [ tree { label = "userZ", emission = Just 5 } []
                    , tree { label = "userH", emission = Just 6 } []
                    ]
                ]
            , tree { label = "user2", emission = Just 7 } []
            ]
        , tree { label = "etc", emission = Just 8 } []
        , tree { label = "var", emission = Just 9 }
            [ tree { label = "log", emission = Just 10 } []
            ]
        ]
