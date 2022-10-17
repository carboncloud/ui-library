module Color exposing (black, focus, grey050, grey100, grey200, grey300, grey500, grey800, primary050, primary500, primary600, secondary050, secondary500, success, warn050, warn500, white, secondary600, warn600)

import Css exposing (Color)



-- TODO: confirm colors


primary050 : Color
primary050 =
    Css.hex "#CAE8E9"


primary500 : Color
primary500 =
    Css.hex "#28a0a6"


primary600 : Color
primary600 =
    Css.hex "#287387"


secondary050 : Color
secondary050 =
    Css.hex "#E6E8F5"


secondary500 : Color
secondary500 =
    Css.hex "#364286"

secondary600 : Color
secondary600 =
    Css.hex "#2F3974"


blueberry : Color
blueberry =
    Css.hex "#364286"


peach : Color
peach =
    Css.hex "#FA876A"


grey050 : Color
grey050 =
    Css.hex "#FCFCFC"


grey100 : Color
grey100 =
    Css.hex "#f8f8f8"


grey200 : Color
grey200 =
    Css.hex "#E3E3E3"


grey300 : Color
grey300 =
    Css.hex "#e8e8e8"


grey500 : Color
grey500 =
    Css.hex "#858585"


grey800 : Color
grey800 =
    Css.hex "#464646"


white : Color
white =
    Css.hex "#ffffff"


black : Color
black =
    Css.hex "#05050a"


success : Color
success =
    Css.hex "#b5f7b5"


warn050 : Color
warn050 =
    Css.hex "#FEEFEC"


warn500 : Color
warn500 =
    Css.hex "#fa876a"

warn600 : Color
warn600 =
    Css.hex "#D95E3F"


focus : Color
focus =
    Css.hex "#172D69"
