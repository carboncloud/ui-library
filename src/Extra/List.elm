module Extra.List exposing (takeLast)


takeLast : Int -> List a -> List a
takeLast x =
    List.reverse << List.take x << List.reverse
