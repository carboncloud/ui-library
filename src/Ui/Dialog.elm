module Ui.Dialog exposing (..)

import Accessibility.Styled as Html exposing (Html)
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Css
import Html.Styled.Attributes as Attributes
import String.Extra exposing (dasherize)
import Ui.Shadow as Shadow exposing (shadow)


view : { title : String, content : Html msg, onClose : msg, actionButtons : List (Html msg) } -> Html msg
view { title, content, onClose, actionButtons } =
    Html.div
        [ Role.dialog
        , Aria.labelledBy <| dasherize title
        , Aria.labelledBy <| dasherize title
        , Attributes.css <|
            [ Css.position Css.fixed
            , Css.padding (Css.px 15)
            , Css.borderRadius (Css.px 5)
            , shadow Shadow.Large
            ]
        ]
        [ Html.text "Dialog" ]
