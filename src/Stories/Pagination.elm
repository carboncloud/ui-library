module Stories.Pagination exposing (..)

import Html exposing (Html, span, text)
import Html.Styled exposing (toUnstyled)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Ui.Pagination


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
    { paginationModel : Ui.Pagination.Model }


init =
    { paginationModel = Ui.Pagination.init }


type Msg
    = UserSelectedPageNumber Ui.Pagination.Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedPageNumber newPaginationModel ->
            { model | paginationModel = newPaginationModel }


view : Controls -> Model -> Html Msg
view controls model =
            toUnstyled <|
                Ui.Pagination.view
                    model.paginationModel
                    { siblingCount = 2
                    , boundaryCount = 1
                    , onNav = UserSelectedPageNumber
                    }
