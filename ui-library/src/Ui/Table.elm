module Ui.Table exposing
    ( ColumnAlignment(..)
    , ColumnConfig
    , Flex(..)
    , Model
    , Msg
    , SortDirection(..)
    , TableConfig
    , addColumn
    , addExtendableView
    , cellColumns
    , cellCustom
    , cellFloat
    , cellInt
    , cellLink
    , cellRows
    , cellText
    , column
    , columnWithDataEntryId
    , defaultConfig
    , hideColumn
    , setColumnAlignment
    , setColumnWidth
    , showColumn
    , update
    , view
    )

import Css
import Css.Transitions exposing (transition)
import Dict exposing (Dict)
import Html.Styled exposing (Attribute, Html, a, div, span)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Keyed exposing (lazyNode3)
import List
import Maybe.Extra exposing (isJust)
import Ui.Css.Palette as Palette
import Ui.Css.TextStyle exposing (toCssStyle)
import Ui.Icon
import Ui.Palette
import Ui.Text as Text
import Ui.TextStyle as TextStyle exposing (TextStyle)


type SortDirection
    = Ascending
    | Descending


type ColumnAlignment
    = Left
    | Center
    | Right


type ColumnContent msg
    = ColumnContent (Html msg)


type alias ColumnConfig record msg =
    { name : String
    , width : Css.LengthOrAuto Css.Px
    , content : DataEntryId -> record -> ColumnContent msg
    , visible : Bool
    , alignment : ColumnAlignment
    , weight : Int
    }


type alias TableConfig record msg =
    { columns : Dict ColumnId (ColumnConfig record msg)
    , onHeaderClick : Maybe (ColumnId -> msg)
    , extendableView : Maybe (record -> Html msg)
    , liftMsg : Msg -> msg
    }


type alias Model record =
    { sortDirection : SortDirection
    , sortIndex : String
    , data : Dict DataEntryId ( record, Bool )
    }


type alias ColumnId =
    String


type alias DataEntryId =
    String


type Msg
    = ToggleAccordionView DataEntryId


update : Msg -> Model v -> ( Model v, Cmd Msg )
update msg model =
    case msg of
        ToggleAccordionView dId ->
            ( { model
                | data =
                    Dict.update dId
                        (Maybe.map <|
                            \entry ->
                                ( Tuple.first entry
                                , not <| Tuple.second entry
                                )
                        )
                        model.data
              }
            , Cmd.none
            )


defaultConfig : (Msg -> msg) -> TableConfig record msg
defaultConfig liftMsg =
    { onHeaderClick = Nothing
    , columns = Dict.empty
    , extendableView = Nothing
    , liftMsg = liftMsg
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
    ColumnConfig name length (always content) True a


columnWithDataEntryId :
    String
    -> Css.LengthOrAuto Css.Px
    -> (DataEntryId -> record -> ColumnContent msg)
    -> ColumnAlignment
    -> Int
    -> ColumnConfig record msg
columnWithDataEntryId name length content a =
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


cellContentStyle : Attribute msg
cellContentStyle =
    css [ Css.flexGrow (Css.num 1) ]


unwrapColumnContent : ColumnContent msg -> Html msg
unwrapColumnContent (ColumnContent x) =
    x


cellColumns : Flex -> List (ColumnContent msg) -> ColumnContent msg
cellColumns w =
    ColumnContent
        << div
            [ css
                ([ Css.displayFlex
                 , Css.flexDirection Css.row
                 , Css.height (Css.pct 100)
                 , Css.whiteSpace Css.normal
                 ]
                    ++ flexToStyle w
                )
            ]
        << List.map unwrapColumnContent



-- Table.cellColumn Table.Grow [ row Table.Grow [ text ..., int... ], icon ..., ]


cellText : TextStyle -> String -> ColumnContent msg
cellText textStyle =
    ColumnContent << Text.customView [ cellContentStyle ] textStyle


cellInt : Int -> ColumnContent msg
cellInt =
    ColumnContent << Text.customView [ cellContentStyle ] TextStyle.monospace << String.fromInt


cellFloat : Float -> ColumnContent msg
cellFloat =
    ColumnContent << Text.customView [ cellContentStyle ] TextStyle.monospace << String.fromFloat


cellLink : TextStyle -> { url : String, text : String } -> ColumnContent msg
cellLink textStyle { url, text } =
    ColumnContent <| a [ href url ] [ Text.view (textStyle |> TextStyle.withColor TextStyle.linkColor) text ]


cellCustom : Html msg -> ColumnContent msg
cellCustom =
    ColumnContent


type Flex
    = Auto
    | Shrink
    | Grow


flexToStyle : Flex -> List Css.Style
flexToStyle x =
    case x of
        Auto ->
            [ Css.flex <| Css.num 1 ]

        Shrink ->
            [ Css.flexShrink (Css.num 0), Css.flexBasis Css.auto ]

        Grow ->
            [ Css.flexGrow (Css.num 1) ]


cellRows : Flex -> List (ColumnContent msg) -> ColumnContent msg
cellRows w =
    ColumnContent
        << div
            [ css
                ([ Css.displayFlex
                 , Css.flexDirection Css.column
                 , Css.whiteSpace Css.normal
                 ]
                    ++ flexToStyle w
                )
            ]
        << List.map unwrapColumnContent


headerStyle : List Css.Style
headerStyle =
    toCssStyle (TextStyle.bodySmall |> TextStyle.withColor Ui.Palette.gray300)


cellPadding : Attribute msg
cellPadding =
    css [ Css.padding2 (Css.px 10) (Css.px 8) ]


alignment : { a | alignment : ColumnAlignment } -> Attribute msg
alignment col =
    case col.alignment of
        Left ->
            css [ Css.justifyContent Css.left, Css.textAlign Css.left ]

        Center ->
            css [ Css.justifyContent Css.center, Css.textAlign Css.center ]

        Right ->
            css [ Css.justifyContent Css.right, Css.textAlign Css.right ]


view :
    List (Attribute msg)
    -> TableConfig record msg
    -> Model record
    -> Html msg
view attributes { liftMsg, columns, extendableView } { sortIndex, sortDirection, data } =
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
                    , Css.borderBottom3 (Css.px 1) Css.solid Palette.gray200
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

        row : String -> record -> Bool -> Html msg
        row dId r expanded =
            div
                [ css
                    [ Css.displayFlex
                    , Css.flexDirection Css.column
                    , Css.borderBottom3 (Css.px 1) Css.solid Palette.gray200
                    , Css.lastChild [ Css.borderBottom Css.zero ]
                    ]
                ]
                [ div
                    (css
                        [ Css.displayFlex
                        , Css.flexDirection Css.row
                        , Css.cursor Css.pointer
                        , Css.hover [ Css.backgroundColor Palette.gray100 ]
                        , if isJust extendableView && expanded then
                            Css.borderBottom3 (Css.px 1) Css.solid Palette.gray200

                          else
                            Css.border Css.zero
                        ]
                        :: (if isJust extendableView then
                                [ onClick <| liftMsg <| ToggleAccordionView dId ]

                            else
                                []
                           )
                    )
                  <|
                    List.map
                        (\( _, colConfig ) ->
                            let
                                (ColumnContent content) =
                                    colConfig.content dId r
                            in
                            div
                                [ css
                                    [ Css.width colConfig.width
                                    , Css.displayFlex
                                    , Css.alignItems Css.center
                                    ]
                                , alignment colConfig
                                , cellPadding
                                , css [ Css.boxSizing Css.borderBox ]
                                ]
                            <|
                                [ content ]
                        )
                        colList
                , case extendableView of
                    Just accordionView ->
                        div
                            [ css
                                [ Css.width (Css.pct 100)
                                , Css.backgroundColor Palette.gray100
                                , Css.overflow Css.hidden
                                , Css.height Css.auto
                                , Css.displayFlex
                                , transition [ Css.Transitions.maxHeight3 300 0 <| Css.Transitions.cubicBezier 0.87 0 0.13 1 ]
                                , if expanded then
                                    Css.maxHeight (Css.px 400)

                                  else
                                    Css.maxHeight (Css.px 0)
                                , Css.boxSizing Css.borderBox
                                ]
                            ]
                            [ div
                                [ css
                                    [ Css.padding2 (Css.px 15) (Css.px 15)
                                    , Css.flex (Css.num 1)
                                    ]
                                ]
                                [ accordionView r ]
                            ]

                    _ ->
                        span [] []
                ]
    in
    div (css [ Css.border3 (Css.px 1) Css.solid Palette.gray200 ] :: attributes)
        (header
            :: (List.singleton <|
                    lazyNode3 "div" [] row <|
                        List.map (\( k, ( r, b ) ) -> ( k, ( k, r, b ) )) <|
                            List.take 50 <|
                                Dict.toList data
               )
        )
