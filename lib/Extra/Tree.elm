module Extra.Tree exposing (hasChildren)

import Tree exposing (Tree)


hasChildren : Tree a -> Bool
hasChildren x =
    List.length (Tree.children x) /= 0
