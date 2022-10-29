module Ui.Internal.FontWeight exposing (..)


{-| Represents a font weight
-}
type FontWeight
    = Light
    | Regular
    | SemiBold
    | Bold


{-| Return the weight of a font
-}
fontWeight : FontWeight -> Int
fontWeight weight =
    case weight of
        Light ->
            300

        Regular ->
            400

        SemiBold ->
            600

        Bold ->
            700
