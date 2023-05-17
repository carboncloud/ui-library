module Ui.Table exposing
    ( ColumnAlignment(..)
    , ColumnConfig
    , Model
    , SortDirection(..)
    , TableConfig
    , addColumn
    , addContentColumn
    , addContentRow
    , addExtendableView
    , column
    , columnFloat
    , columnInt
    , columnText
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
import List.Nonempty as Nonempty exposing (Nonempty)
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


type ColumnContent msg
    = ColumnContent (Nonempty (Html msg))


columnText : String -> ColumnContent msg
columnText =
    ColumnContent << Nonempty.singleton << Text.customView [ css [ Css.flex (Css.num 1) ] ] TextStyle.body


columnInt : Int -> ColumnContent msg
columnInt =
    ColumnContent << Nonempty.singleton << Text.view TextStyle.monospace << String.fromInt


columnFloat : Float -> ColumnContent msg
columnFloat =
    ColumnContent << Nonempty.singleton << Text.view TextStyle.monospace << String.fromFloat


addContentRow : ColumnContent msg -> ColumnContent msg -> ColumnContent msg
addContentRow (ColumnContent c1) (ColumnContent c2) =
    ColumnContent <|
        Nonempty.singleton <|
            div
                [ css
                    [ Css.displayFlex
                    , Css.flexDirection Css.column
                    ]
                ]
            <|
                Nonempty.toList c2
                    ++ Nonempty.toList c1


addContentColumn : ColumnContent msg -> ColumnContent msg -> ColumnContent msg
addContentColumn (ColumnContent c1) (ColumnContent c2) =
    ColumnContent <|
        Nonempty.singleton <|
            div
                [ css
                    [ Css.displayFlex
                    , Css.flexDirection Css.row
                    ]
                ]
            <|
                Nonempty.toList c2
                    ++ Nonempty.toList c1


type alias ColumnConfig record msg =
    { name : String
    , width : Css.LengthOrAuto Css.Px
    , content : record -> ColumnContent msg
    , visible : Bool
    , alignment : ColumnAlignment
    , weight : Int
    }


type alias TableConfig record msg =
    { mRowOnClick : Maybe (record -> msg)
    , columns : Dict String (ColumnConfig record msg)
    , onHeaderClick : Maybe (String -> msg)
    , extendableView : Maybe (record -> Html msg)
    }


type alias Model record =
    { sortDirection : SortDirection
    , sortIndex : String
    , data : List ( record, Bool )
    }


defaultConfig : TableConfig record msg
defaultConfig =
    { mRowOnClick = Nothing
    , onHeaderClick = Nothing
    , columns = Dict.empty
    , extendableView = Nothing
    }


addColumn :
    ( String, Int -> ColumnConfig record msg )
    -> TableConfig record msg
    -> TableConfig record msg
addColumn ( k, v ) config =
    { config | columns = Dict.insert k (v <| Dict.size config.columns) config.columns }


addExtendableView : (record -> Html msg) -> TableConfig record msg -> TableConfig record msg
addExtendableView extendableView config =
    { config | extendableView = Just extendableView }


column :
    String
    -> Css.LengthOrAuto Css.Px
    -> (record -> ColumnContent msg)
    -> ColumnAlignment
    -> Int
    -> ColumnConfig record msg
column name length content a =
    ColumnConfig name length content True a


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
    css [ Css.padding2 (Css.px 10) (Css.px 8), Css.margin2 Css.auto Css.zero ]


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
view attributes { mRowOnClick, columns, extendableView } { sortIndex, sortDirection, data } =
    let
        colList =
            List.sortBy (.weight << Tuple.second) <|
                Dict.toList <|
                    Dict.filter (\_ v -> v.visible) columns

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
                            , css [ Css.boxSizing Css.borderBox ]
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

        row : ( record, Bool ) -> Html msg
        row ( r, expanded ) =
            div []
                [ div
                    [ css
                        [ Css.displayFlex
                        , Css.flexDirection Css.row
                        , Css.borderBottom3 (Css.px 1) Css.solid Palette.gray100
                        ]
                    ]
                  <|
                    List.map
                        (\( _, colConfig ) ->
                            let
                                (ColumnContent content) =
                                    colConfig.content r
                            in
                            div
                                [ css
                                    [ Css.width colConfig.width
                                    , Css.borderRight3 (Css.px 1) Css.solid Palette.gray100
                                    ]
                                , alignment colConfig
                                , cellPadding
                                , css [ Css.boxSizing Css.borderBox ]
                                ]
                            <|
                                Nonempty.toList content
                        )
                        colList
                , if expanded then
                    div
                        [ css
                            [ Css.width (Css.pct 100)
                            , Css.backgroundColor Palette.primary050
                            , Css.padding2 (Css.px 20) (Css.px 15)
                            ]
                        , css [ Css.boxSizing Css.borderBox ]
                        ]
                        [ Maybe.map (\v -> v r) extendableView |> Maybe.withDefault (span [] []) ]

                  else
                    span [] []
                ]
    in
    div [] (header :: List.map row data)
