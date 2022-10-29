module Ui.Internal.FontSize exposing (..)

import Css exposing (Rem)
import Rpx exposing (rpx)

{-| Represents a font size
-}
type FontSize
    = Small
    | Normal
    | Large
    | XL
    | XXL


{-| Return the size of a font
-}
fontSize : FontSize -> Rem
fontSize size =
    case size of
        Small ->
            rpx 14

        Normal ->
            rpx 16

        Large ->
            rpx 18

        XL ->
            rpx 43

        XXL ->
            rpx 53
