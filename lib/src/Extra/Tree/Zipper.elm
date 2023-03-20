module Extra.Tree.Zipper exposing (hasChildren, isFocused, isParent)


import Tree.Zipper as Zipper exposing (Zipper)




isFocused : Zipper a -> a -> Bool
isFocused =
    (==) << Zipper.label



isParent : Zipper a -> a -> Bool
isParent zipper label =
    case Zipper.parent zipper of
        Nothing ->
            False

        Just p ->
            if Zipper.label p == label then
                True

            else
                isParent p label


hasChildren : Zipper a -> Bool
hasChildren x =
    case Zipper.children x of
        [] ->
            False

        _ ->
            True
