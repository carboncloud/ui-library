module Stories.Table exposing (..)

import Css exposing (displayFlex, flex)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css)
import Storybook.Component exposing (Component)
import Storybook.Controls
import Svg.Styled exposing (toUnstyled)
import Ui.Table as Table exposing (ColumnConfig, TableConfig)


main : Component () Msg
main =
    Storybook.Component.stateless
        { controls = Storybook.Controls.none
        , view = always view
        }


type Msg
    = OrderHeader String


tableConfig : TableConfig TableData Msg
tableConfig =
    Table.defaultConfig
        |> Table.addColumn
            ( "name"
            , Table.column "Name"
                (Css.px 200)
                (\{ description, subtitle } ->
                    Table.columnText description
                        |> Table.addContentRow (Table.columnText subtitle)
                        |> Table.addContentRow
                            (Table.columnText "third thing"
                                |> Table.addContentColumn (Table.columnText "?")
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
        |> Table.addColumn ( "test3", Table.column "Test3" (Css.px 120) (always (Table.columnText "TODO") << .actions) Table.Left )
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


view : Html Msg
view =
    toUnstyled <|
        Table.view []
            tableConfig
            { sortDirection = Table.Ascending
            , sortIndex = ""
            , data =
                [ ( { description = "hello world"
                    , subtitle = "my first subtitle"
                    , count = 12
                    , value = 1.023
                    , date = 1
                    , actions = []
                    }
                  , True
                  )
                , ( { description = "some other thing"
                    , subtitle = "my second subtitle"
                    , count = 42
                    , value = 2.123
                    , date = 1
                    , actions = []
                    }
                  , False
                  )
                ]
            }
