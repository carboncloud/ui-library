module Ui.Typography exposing (..)

import Css exposing (FontWeight)
import Ui.Color exposing (Color)
import Ui.Palette exposing (palette)


type Typography
    = Typography Family Size Weight Color


type Family
    = Family String


family : Typography -> String
family (Typography (Family x) _ _ _) =
    x


type Size
    = Size Float


size : Typography -> Float
size (Typography _ (Size x) _ _) =
    x


type Weight
    = Weight Int


weight : Typography -> Int
weight (Typography _ _ (Weight x) _) =
    x


color : Typography -> Color
color (Typography _ _ _ x) =
    x


poppins =
    Family "Poppins"


small =
    Size 14


normal =
    Size 16


large =
    Size 18


regular =
    Weight 500


bold =
    Weight 800


bodyS =
    Typography poppins small regular palette.grey200


body =
    Typography poppins normal regular palette.grey500

bodyL = Typography poppins large regular palette.grey500

header =
    Typography poppins large bold palette.grey800
