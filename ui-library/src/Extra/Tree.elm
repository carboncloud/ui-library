module Extra.Tree exposing (hasChildren)

import Tree exposing (Tree)


hasChildren : Tree a -> Bool
hasChildren t =
    case Tree.children t of
        [] ->
            False

        _ ->
            True
