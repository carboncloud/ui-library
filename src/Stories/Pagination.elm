module Stories.Pagination exposing (..)

import Dict
import Html exposing (Html)
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
    { selectedPageNumber : Ui.Pagination.PageNumber }


init =
    { selectedPageNumber = Ui.Pagination.initPageNumber }


type Msg
    = UserSelectedPageNumber Ui.Pagination.PageNumber


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedPageNumber pageNumber ->
            { model | selectedPageNumber = pageNumber }


view : Controls -> Model -> Html Msg
view controls model =
    toUnstyled <|
        Ui.Pagination.view
            { currentPage = model.selectedPageNumber
            , numberOfPages = 10
            }
            { siblingCount = 1
            , boundaryCount = 1
            , onNav = UserSelectedPageNumber
            }
