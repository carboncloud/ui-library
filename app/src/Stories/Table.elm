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


tableConfig : TableConfig String Msg
tableConfig =
    Table.defaultConfig
        |> Table.addColumn ( "name", Table.column "Name" (Css.px 80) Styled.text Table.Left )
        |> Table.addColumn ( "output", Table.column "Output" (Css.px 80) Styled.text Table.Center )
        |> Table.addColumn ( "market", Table.column "Market" (Css.px 80) Styled.text Table.Right )
        |> Table.addColumn ( "test3", Table.column "Test3" (Css.px 80) Styled.text Table.Left )



-- |> Table.hideColumn "test2"


view : Html Msg
view =
    toUnstyled <| Table.view [] tableConfig { sortDirection = Table.Ascending, sortIndex = "", data = [ "hello world" ] }
