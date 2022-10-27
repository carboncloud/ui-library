module Ui.Palette exposing
    ( black
    , focus
    , grey050
    , grey100
    , grey200
    , grey300
    , grey500
    , grey800
    , primary050
    , primary500
    , primary600
    , secondary050
    , secondary500
    , secondary600
    , success
    , success050
    , warn050
    , warn500
    , warn600
    , white
    )

import Ui.Color as Color exposing (Color, rgb)



-- TODO: confirm colors


primary050 : Color
primary050 =
    hex "#CAE8E9"


primary500 : Color
primary500 =
    hex "#00787d"


primary600 : Color
primary600 =
    hex "#287387"


secondary050 : Color
secondary050 =
    hex "#E6E8F5"


secondary500 : Color
secondary500 =
    hex "#364286"


secondary600 : Color
secondary600 =
    hex "#2F3974"


grey050 : Color
grey050 =
    hex "#FCFCFC"


grey100 : Color
grey100 =
    hex "#f8f8f8"


grey200 : Color
grey200 =
    hex "#E3E3E3"


grey300 : Color
grey300 =
    hex "#e8e8e8"


grey500 : Color
grey500 =
    hex "#858585"


grey800 : Color
grey800 =
    hex "#464646"


white : Color
white =
    hex "#ffffff"


black : Color
black =
    hex "#05050a"


success : Color
success =
    hex "#b5f7b5"


warn050 : Color
warn050 =
    hex "#FEEFEC"


warn500 : Color
warn500 =
    hex "#fa876a"


warn600 : Color
warn600 =
    hex "#D95E3F"


focus : Color
focus =
    hex "#172D69"


success050 : Color
success050 =
    hex "#172D69"


hex : String -> Color
hex =
    Maybe.withDefault (rgb 1 0 0) << Color.fromHex
