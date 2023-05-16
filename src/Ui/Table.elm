module Ui.Table exposing
    ( ColumnAlignment(..)
    , ColumnConfig
    , Model
    , SortDirection(..)
    , TableConfig
    , addColumn
    , column
    , defaultConfig
    , hideColumn
    , setColumnAlignment
    , setColumnWidth
    , showColumn
    , view
    )

import Css exposing (AlignItems)
import Dict exposing (Dict)
import Html.Styled exposing (Attribute, Html, div, span)
import Html.Styled.Attributes exposing (align, css)
import List
import Ui.Css.Palette as Palette
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.Icon
import Ui.Palette
import Ui.Text as Text
import Ui.TextStyle as TextStyle


type SortDirection
    = Ascending
    | Descending


type ColumnAlignment
    = Left
    | Center
    | Right


type alias ColumnConfig record msg =
    { name : String
    , width : Css.LengthOrAuto Css.Px
    , view : record -> Html msg
    , visible : Bool
    , alignment : ColumnAlignment
    , weight : Int
    }


type alias TableConfig record msg =
    { mRowOnClick : Maybe (record -> msg)
    , columns : Dict String (ColumnConfig record msg)
    , onHeaderClick : Maybe (String -> msg)
    }


type alias Model record =
    { sortDirection : SortDirection
    , sortIndex : String
    , data : List record
    }


defaultConfig : TableConfig record msg
defaultConfig =
    { mRowOnClick = Nothing
    , onHeaderClick = Nothing
    , columns = Dict.empty
    }


addColumn :
    ( String, Int -> ColumnConfig record msg )
    -> TableConfig record msg
    -> TableConfig record msg
addColumn ( k, v ) config =
    { config | columns = Dict.insert k (v <| Dict.size config.columns) config.columns }


column :
    String
    -> Css.LengthOrAuto Css.Px
    -> (record -> Html msg)
    -> ColumnAlignment
    -> Int
    -> ColumnConfig record msg
column name length colView a =
    ColumnConfig name length colView True a


hideColumn :
    String
    -> TableConfig record msg
    -> TableConfig record msg
hideColumn k =
    setColumnVisbility k False


showColumn :
    String
    -> TableConfig record msg
    -> TableConfig record msg
showColumn k =
    setColumnVisbility k True


setColumnVisbility :
    String
    -> Bool
    -> TableConfig record msg
    -> TableConfig record msg
setColumnVisbility k visibility =
    updateColumn k (\v -> { v | visible = visibility })


setColumnWidth :
    String
    -> Css.LengthOrAuto Css.Px
    -> TableConfig record msg
    -> TableConfig record msg
setColumnWidth k w =
    updateColumn k (\v -> { v | width = w })


setColumnAlignment :
    String
    -> ColumnAlignment
    -> TableConfig record msg
    -> TableConfig record msg
setColumnAlignment k a =
    updateColumn k (\v -> { v | alignment = a })


updateColumn :
    String
    -> (ColumnConfig record msg -> ColumnConfig record msg)
    -> TableConfig record msg
    -> TableConfig record msg
updateColumn k f config =
    { config | columns = Dict.update k (Maybe.map f) config.columns }


headerStyle =
    toCssStyle (TextStyle.bodySmall |> TextStyle.withColor Ui.Palette.gray300)


cellPadding =
    css [ Css.padding4 (Css.px 10) (Css.px 5) (Css.px 0) (Css.px 5) ]


alignment col =
    case col.alignment of
        Left ->
            css [ Css.textAlign Css.left ]

        Center ->
            css [ Css.textAlign Css.center ]

        Right ->
            css [ Css.textAlign Css.right ]


view :
    List (Attribute msg)
    -> TableConfig record msg
    -> Model record
    -> Html msg
view attributes { mRowOnClick, columns } { sortIndex, sortDirection, data } =
    let
        colList =
            List.sortBy (.weight << Tuple.second) <| Dict.toList <| Dict.filter (\_ v -> v.visible) columns

        header : Html msg
        header =
            div
                [ css <|
                    [ Css.displayFlex
                    , Css.flexDirection Css.row
                    , Css.borderBottom3 (Css.px 1) Css.solid Palette.gray100
                    ]
                        ++ headerStyle
                ]
            <|
                List.map
                    (\( colId, colConfig ) ->
                        div
                            [ css
                                [ Css.width colConfig.width

                                --, Css.borderRight3 (Css.px 1) Css.solid Palette.gray100
                                ]
                            , alignment colConfig
                            , cellPadding
                            ]
                            [ Text.view (TextStyle.bodySmall |> TextStyle.withColor Ui.Palette.gray500) <|
                                colConfig.name
                            , case ( colId == sortIndex, sortDirection ) of
                                ( True, Ascending ) ->
                                    Ui.Icon.view Ui.Icon.chevronDown

                                ( True, Descending ) ->
                                    Ui.Icon.view Ui.Icon.chevronUp

                                _ ->
                                    span [] []
                            ]
                    )
                    colList

        row : record -> Html msg
        row item =
            div
                [ css
                    [ Css.displayFlex
                    , Css.flexDirection Css.row
                    , Css.borderBottom3 (Css.px 1) Css.solid Palette.gray100
                    ]
                ]
            <|
                List.map
                    (\( _, colConfig ) ->
                        div
                            [ css
                                [ Css.width colConfig.width
                                , Css.borderRight3 (Css.px 1) Css.solid Palette.gray100
                                ]
                            , cellPadding
                            ]
                            [ colConfig.view item ]
                    )
                    colList
    in
    div [] (header :: List.map row data)
