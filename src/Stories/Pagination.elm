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
    { paginationModel : Result String Ui.Pagination.Model }


init =
    { paginationModel = Ui.Pagination.init 10 1 }


type Msg
    = UserSelectedPageNumber Ui.Pagination.Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        UserSelectedPageNumber newPaginationModel ->
            { model | paginationModel = Ok newPaginationModel }


view : Controls -> Model -> Html Msg
view _ model =
    case model.paginationModel of
        Ok paginationModel ->
            toUnstyled <|
                Ui.Pagination.view
                    paginationModel
                    { siblingCount = 1
                    , boundaryCount = 1
                    , onNav = UserSelectedPageNumber
                    }

        Err s ->
            span [] [ text s ]
