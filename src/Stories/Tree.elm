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
    { treeModel : Tree.Model String }


init : Model
init =
    { treeModel = Tree.init defaultTreeModel }


type Msg
    = GotTreeMsg (Tree.Msg String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotTreeMsg treeMsg ->
            { model | treeModel = Tree.update treeMsg model.treeModel }


view : Model -> Html Msg
view { treeModel } =
    Styled.toUnstyled <|
        Styled.div [ css [ Css.width (Css.px 500), Css.height (Css.px 1000) ] ]
            [ Tree.view { showLabel = identity, liftMsg = GotTreeMsg } treeModel
            , Styled.text <| "Selected: " ++ Tree.selected treeModel
            ]


defaultTreeModel : Tree String
defaultTreeModel =
    tree "root"
        [ tree "home"
            [ tree "user1"
                [ tree "userX" []
                , tree "userY"
                    [ tree "userZ" []
                    , tree "userH" []
                    ]
                ]
            , tree "user2" []
            ]
        , tree "etc" []
        , tree "var"
            [ tree "log" []
            ]
        ]
