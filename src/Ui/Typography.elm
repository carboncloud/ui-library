module Ui.Typography exposing (..)

import Ui.Color exposing (Color)
import Ui.Palette as Palette

type Typography
    = Typography
        { family : Family
        , size : Size
        , weight : Weight
        , color : Color
        }


type Family
    = Family String


unwrapFamily : Family -> String
unwrapFamily (Family x) =
    x


fontFamily : Typography -> String
fontFamily (Typography { family }) =
    unwrapFamily family


type Size
    = Size Float


unwrapSize : Size -> Float
unwrapSize (Size x) =
    x


fontSize : Typography -> Float
fontSize (Typography { size }) =
    unwrapSize size


type Weight
    = Weight Int


unwrapWeight : Weight -> Int
unwrapWeight (Weight x) =
    x


fontWeight : Typography -> Int
fontWeight (Typography { weight }) =
    unwrapWeight weight


fontColor : Typography -> Color
fontColor (Typography { color }) =
    color


poppins : Family
poppins =
    Family "Poppins"


small : Size
small =
    Size 14


normal : Size
normal =
    Size 16


large : Size
large =
    Size 18


regular : Weight
regular =
    Weight 500


bold : Weight
bold =
    Weight 800


bodyS : Typography
bodyS =
    Typography
        { family = poppins
        , size = small
        , weight = regular
        , color = Palette.grey200
        }


body : Typography
body =
    Typography
        { family = poppins
        , size = normal
        , weight = regular
        , color = Palette.grey500
        }


bodyL : Typography
bodyL =
    Typography
        { family = poppins
        , size = large
        , weight = regular
        , color = Palette.grey500
        }


header : Typography
header =
    Typography
        { family = poppins
        , size = large
        , weight = bold
        , color = Palette.grey800
        }
