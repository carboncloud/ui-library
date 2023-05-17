module Stories.Table exposing (..)

import Css exposing (displayFlex, flex)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (desc, toUnstyled)
import Ui.Button
import Ui.Icon
import Ui.Table as Table exposing (ColumnConfig, TableConfig)


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
    { tableModel : Table.Model TableData }


type Msg
    = GotTableMsg Table.Msg
    | OpenDataEntryActionMenu String


init =
    { tableModel =
        { sortDirection = Table.Ascending
        , sortIndex = ""
        , data =
            Dict.fromList <|
                [ ( "0"
                  , ( { description = "hello world"
                      , subtitle = "my first subtitle"
                      , count = 12
                      , value = 1.023
                      , date = 1
                      , actions = []
                      }
                    , False
                    )
                  )
                , ( "1"
                  , ( { description = "some other thing"
                      , subtitle = "my second subtitle"
                      , count = 42
                      , value = 2.123
                      , date = 1
                      , actions = []
                      }
                    , False
                    )
                  )
                ]
        }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTableMsg tableMsg ->
            let
                ( tableModel, tableCmd ) =
                    Table.update tableMsg model.tableModel
            in
            ( { model | tableModel = tableModel }, Cmd.map GotTableMsg tableCmd )

        OpenDataEntryActionMenu _ ->
            ( model, Cmd.none )


tableConfig : TableConfig TableData Msg
tableConfig =
    Table.defaultConfig GotTableMsg
        |> Table.addColumn
            ( "name"
            , Table.column "Name"
                (Css.px 200)
                (\{ description, subtitle } ->
                    (Table.columnText description
                        |> Table.addContentRow (Table.columnText subtitle)
                    )
                        |> Table.addContentColumn (Table.columnText "!")
                )
                Table.Left
            )
        |> Table.addColumn
            ( "output"
            , Table.column "Output" (Css.px 120) (Table.columnFloat << .value) Table.Right
            )
        |> Table.addColumn
            ( "market"
            , Table.column "Market" (Css.px 120) (Table.columnInt << .date) Table.Right
            )
        |> Table.addColumn
            ( "actions"
            , Table.column "Actions"
                (Css.px 120)
                (\{ description } ->
                    Table.columnCustom <|
                        Ui.Button.iconButton []
                            { onClick = Just <| OpenDataEntryActionMenu description
                            , icon = Ui.Icon.edit
                            , tooltip = "entry-actions"
                            }
                )
                Table.Center
            )
        |> Table.addExtendableView (Styled.text << .description)



-- |> Table.hideColumn "test2"


type alias TableData =
    { description : String
    , subtitle : String
    , count : Int
    , value : Float
    , date : Int
    , actions : List Msg
    }


view : Model -> Html Msg
view model =
    toUnstyled <|
        Table.view []
            tableConfig
            model.tableModel
