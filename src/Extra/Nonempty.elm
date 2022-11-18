module Extra.Nonempty exposing (..)

import Extra.List as CCList
import List.Nonempty as Nonempty exposing (Nonempty(..))


init : Nonempty a -> Nonempty a
init x =
    Nonempty (Nonempty.head x) <| CCList.dropLast 1 <| Nonempty.tail x
