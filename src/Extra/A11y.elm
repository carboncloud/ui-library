module Extra.A11y exposing (whenJust)

import Accessibility.Styled as A11y exposing (Html)


whenJust : Maybe a -> (a -> Html msg) -> Html msg
whenJust ma f =
    case ma of
        Just a ->
            f a

        Nothing ->
            A11y.span [] []
