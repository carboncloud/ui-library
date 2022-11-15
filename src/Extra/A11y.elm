module Extra.A11y exposing (whenJust)

import Accessibility.Styled as A11y exposing (Html)


whenJust : (a -> Html msg) -> Maybe a -> Html msg
whenJust f ma =
    case ma of
        Just a ->
            f a

        Nothing ->
            Debug.todo ""
