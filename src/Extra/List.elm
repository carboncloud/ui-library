module Extra.List exposing (takeLast, dropLast)

takeLast : Int -> List a -> List a
takeLast x = List.reverse << List.take x << List.reverse 


dropLast : Int -> List a -> List a
dropLast x = List.reverse << List.drop x << List.reverse
