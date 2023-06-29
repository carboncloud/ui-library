module Stories.Pagination exposing (..)

import Html exposing (Html, span)
import Html.Styled exposing (toUnstyled)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Pagination
import ZipList exposing (ZipList(..))


main : Component Model Msg
main =
    Storybook.Component.sandbox
        { controls =
            Storybook.Controls.new Controls
                |> Storybook.Controls.withString
                    { name = "label"
                    , fallback = "Choose your option"
                    }
        , view = view
        , init = init
        , update = update
        }


type alias Controls =
    { label : String
    }


type alias Model =
    { paginationModel : Ui.Pagination.Model Int }


init : Model
init =
    { paginationModel = Ui.Pagination.init pageNumbers }


pageNumbers : ZipList Int
pageNumbers =
    Zipper [] 1 (List.range 2 20)


type Msg
    = UserSelectedPageNumber (Ui.Pagination.Model Int)


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedPageNumber newPaginationModel ->
            { model | paginationModel = newPaginationModel }


view : Controls -> Model -> Html Msg
view _ { paginationModel } =
    toUnstyled <|
        Ui.Pagination.view
            paginationModel
            { siblingCount = 1
            , boundaryCount = 1
            , onNav = UserSelectedPageNumber
            }
