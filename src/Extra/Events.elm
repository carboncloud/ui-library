module Extra.Events exposing (onClickNoPropagation)

import Html exposing (Attribute)
import Html.Events as Events
import Json.Decode as JD


onClickNoPropagation : msg -> Attribute msg
onClickNoPropagation onClick =
    Events.custom "click" (JD.succeed { message = onClick, stopPropagation = True, preventDefault = True })
