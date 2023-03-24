module Extra.Styled exposing (none, when, whenJust)

import Html.Styled exposing (Html, span)


when : Bool -> Html msg -> Html msg
when pred content =
    if pred then
        content

    else
        none


whenJust : (a -> Html msg) -> Maybe a -> Html msg
whenJust f =
    Maybe.map f >> Maybe.withDefault none


none : Html msg
none =
    span [] []
