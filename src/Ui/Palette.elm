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
    , white, disabled
    )

import Color exposing (Color, fromRgba)
import Css
import Ui.Color


-- TODO: confirm colors


primary050 : Color
primary050 =
    Ui.Color.fromHex "#CAE8E9"


primary500 : Color
primary500 =
    Ui.Color.fromHex "#00787d"


primary600 : Color
primary600 =
    Ui.Color.fromHex "#287387"


secondary050 : Color
secondary050 =
    Ui.Color.fromHex "#E6E8F5"


secondary500 : Color
secondary500 =
    Ui.Color.fromHex "#364286"


secondary600 : Color
secondary600 =
    Ui.Color.fromHex "#2F3974"


grey050 : Color
grey050 =
    Ui.Color.fromHex "#FCFCFC"


grey100 : Color
grey100 =
    Ui.Color.fromHex "#f8f8f8"


grey200 : Color
grey200 =
    Ui.Color.fromHex "#E3E3E3"


grey300 : Color
grey300 =
    Ui.Color.fromHex "#e8e8e8"


grey500 : Color
grey500 =
    Ui.Color.fromHex "#858585"


grey800 : Color
grey800 =
    Ui.Color.fromHex "#444444"


white : Color
white =
    Ui.Color.fromHex "#ffffff"


black : Color
black =
    Ui.Color.fromHex "#05050a"


success : Color
success =
    Ui.Color.fromHex "#b5f7b5"


warn050 : Color
warn050 =
    Ui.Color.fromHex "#FEEFEC"


warn500 : Color
warn500 =
    Ui.Color.fromHex "#fa876a"


warn600 : Color
warn600 =
    Ui.Color.fromHex "#D95E3F"


focus : Color
focus =
    Ui.Color.fromHex "#4B5FD1"


success050 : Color
success050 =
    Ui.Color.fromHex "#172D69"


disabled : Color
disabled = grey500
