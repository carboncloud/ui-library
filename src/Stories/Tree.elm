module Stories.Tree exposing (..)

import Html exposing (Html)
import Html.Styled as Styled
import Storybook.Component exposing (Component)
import Storybook.Controls
import Tree exposing (tree, Tree)
import Ui.Tree as Tree
import Html.Styled.Attributes exposing (css)
import Css


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls =
            Storybook.Controls.none
        , view = \_ -> view
        , init = init
        , update = update
        }


type alias Model = { treeModel : Tree.Model String }

init : Model
init = { treeModel = Tree.init defaultTreeModel }

type Msg
    = GotTreeMsg (Tree.Msg String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            { model | treeModel = Tree.update treeMsg model.treeModel }


view :  Model -> Html Msg
view { treeModel } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.width (Css.px 500), Css.height (Css.px 1000)]]
            [ Tree.view { showLabel = identity, liftMsg = GotTreeMsg } treeModel ]

defaultTreeModel : Tree String
defaultTreeModel =
    tree "root" [ tree "home"
            [ tree "user1" []
            , tree "user2" []
            ]
        , tree "etc" []
        , tree "var"
            [ tree "log" []
            ]
        ]
