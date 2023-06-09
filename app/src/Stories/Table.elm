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
import Ui.Menu as Menu
import Ui.Table as Table exposing (ColumnConfig, TableConfig)
import Ui.TextStyle as TextStyle


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
    | GotMenuMsg ( String, Menu.Msg )
    | OpenDataEntryActionMenu String
    | SeeMoreActions String
    | Noop


init =
    { tableModel =
        { sortDirection = Table.Ascending
        , sortIndex = ""
        , data = tableData
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

        GotMenuMsg ( entryId, menuMsg ) ->
            let
                entryMenuModel =
                    Dict.update entryId (Maybe.map (\( entry, accordionOpen ) -> ( { entry | actions = Menu.update menuMsg <| entry.actions }, accordionOpen ))) model.tableModel.data

                currentTableModel =
                    model.tableModel
            in
            ( { model | tableModel = { currentTableModel | data = entryMenuModel } }, Cmd.none )

        OpenDataEntryActionMenu _ ->
            ( model, Cmd.none )

        SeeMoreActions _ ->
            ( model, Cmd.none )

        Noop ->
            ( model, Cmd.none )


tableConfig : TableConfig TableData Msg
tableConfig =
    Table.defaultConfig GotTableMsg
        |> Table.addColumn
            ( "name"
            , Table.column "Name"
                (Css.px 300)
                (\{ description, subtitle } ->
                    Table.cellColumns Table.Grow
                        [ Table.cellRows Table.Grow
                            [ Table.cellText TextStyle.body description
                            , Table.cellText TextStyle.bodySmall subtitle
                            ]
                        , Table.cellRows Table.Shrink
                            [ Table.cellCustom <|
                                Styled.div
                                    [ css
                                        [ Css.width (Css.px 32)
                                        , Css.height (Css.px 32)
                                        , Css.margin Css.auto
                                        ]
                                    ]
                                    [ Ui.Icon.view Ui.Icon.approved ]
                            ]
                        ]
                )
                Table.Left
            )
        |> Table.addColumn
            ( "output"
            , Table.column "Output" (Css.px 120) (Table.cellFloat << .value) Table.Right
            )
        |> Table.addColumn
            ( "market"
            , Table.column "Market" (Css.px 120) (Table.cellInt << .date) Table.Right
            )
        |> Table.addColumn
            ( "actions"
            , Table.columnWithDataEntryId ""
                (Css.px 60)
                (\entryId { actions } ->
                    Table.cellCustom <|
                        Menu.view
                            { label = "data-entry-menu"
                            , liftMsg = GotMenuMsg << Tuple.pair entryId
                            , options =
                                [ { name = "Delete"
                                  , icon = Just Ui.Icon.edit
                                  , action = Noop
                                  }
                                , { name = "Copy"
                                  , icon = Just Ui.Icon.edit
                                  , action = Noop
                                  }
                                ]
                            }
                            actions
                )
                Table.Center
            )
        |> Table.addExtendableView (Styled.text << .description)



-- |> Table.hideColumn "test2"


tableData : Dict String ( TableData, Bool )
tableData =
    Dict.fromList <|
        [ ( "first"
          , ( { description = "hello world"
              , subtitle = "my first subtitle"
              , count = 12
              , value = 1.023
              , date = 1
              , actions = { open = False }
              }
            , False
            )
          )
        , ( "second"
          , ( { description = "some other thing"
              , subtitle = "my second subtitle"
              , count = 42
              , value = 2.123
              , date = 1
              , actions = { open = False }
              }
            , False
            )
          )
        ]


type alias TableData =
    { description : String
    , subtitle : String
    , count : Int
    , value : Float
    , date : Int
    , actions : Menu.Model
    }


view : Model -> Html Msg
view model =
    toUnstyled <|
        Table.view []
            tableConfig
            model.tableModel
