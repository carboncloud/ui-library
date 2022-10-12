module Color.Internal exposing (..)

import Css exposing (Color)
import Hex


toHexString : Color -> String
toHexString { red, green, blue } =
    "#"
        ++ Hex.toString red
        ++ Hex.toString green
        ++ Hex.toString blue
