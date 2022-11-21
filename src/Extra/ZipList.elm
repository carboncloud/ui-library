module Extra.ZipList exposing (getInitial, getTail)

import ZipList exposing (ZipList(..))


getInitial : ZipList a -> List a
getInitial (Zipper initial _ _)=
    List.reverse initial


getTail : ZipList a -> List a
getTail (Zipper _ _ tail) =
    tail
