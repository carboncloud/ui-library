module Extra.Styled exposing (none, when, whenJust)

import Html.Styled exposing (Html, span)


when : Bool -> Html msg -> Html msg
when pred content =
    if pred then
        content

    else
        none


whenJust :  Maybe a -> (a -> Html msg) -> Html msg
whenJust x f =
    Maybe.map f x |> Maybe.withDefault none


none : Html msg
none =
    span [] []
